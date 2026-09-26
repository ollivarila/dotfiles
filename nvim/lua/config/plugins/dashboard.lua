local pr_label_width = 70
local button_width = pr_label_width + 4

local function truncate(text, width)
  if vim.fn.strchars(text) <= width then
    return text
  end
  return vim.fn.strcharpart(text, 0, width - 1) .. '…'
end

local function left_aligned_text(val, hl)
  return {
    type = 'text',
    val = val .. string.rep(' ', button_width - vim.fn.strdisplaywidth(val)),
    opts = { position = 'center', hl = hl },
  }
end

local external_sections_dir = vim.fn.expand '~/.config/external-nvim-dashboard-sections'

local function redraw()
  if vim.bo.filetype == 'alpha' then
    require('alpha').redraw()
    -- redraw only reapplies button keymaps when the layout table itself changes
    vim.cmd 'AlphaRemap'
  end
end

local function aligned_button(key, label, on_press)
  local button = require('alpha.themes.dashboard').button(key, label, on_press)
  button.opts.width = button_width
  button.on_press = on_press
  return button
end

local function pr_button(key, pr)
  local repo = pr.repository.name
  local number = '#' .. pr.number
  local label = string.format('%s%s %s', repo, number, pr.title)
  local button = aligned_button(key, truncate(label, pr_label_width), function()
    vim.ui.open(pr.url)
  end)
  button.opts.hl = {
    { 'Function', 0, #repo },
    { 'Number', #repo, #repo + #number },
  }
  return button
end

local function review_requests_section()
  local heading = left_aligned_text('Review requests', 'Title')
  local section = {
    type = 'group',
    val = { heading, left_aligned_text('Loading…', 'Comment') },
    opts = { spacing = 1 },
  }

  local cmd = {
    'gh', 'search', 'prs',
    '--review-requested', 'ollivarila',
    '--state', 'open',
    '--checks', 'success',
    '--limit', '9',
    '--json', 'repository,number,title,url',
    '--', '-label:dependencies', '-label:flag',
  }
  vim.system(cmd, { text = true, timeout = 5000 }, function(res)
    vim.schedule(function()
      local ok, prs = pcall(vim.json.decode, res.stdout or '')
      if res.code ~= 0 or not ok then
        section.val = { heading, left_aligned_text('Failed to load', 'Comment') }
      elseif #prs == 0 then
        section.val = { heading, left_aligned_text('None', 'Comment') }
      else
        section.val = { heading }
        for i, pr in ipairs(prs) do
          table.insert(section.val, pr_button(tostring(i), pr))
        end
      end
      redraw()
    end)
  end)

  return section
end

-- Each file returns function(ctx) -> alpha element | nil, loaded in filename order
local function external_sections(ctx)
  local sections = {}
  local paths = vim.fn.globpath(external_sections_dir, '*.lua', false, true)
  table.sort(paths)
  for _, path in ipairs(paths) do
    local ok, section_or_err = pcall(function()
      local create_section = dofile(path)
      assert(type(create_section) == 'function', 'must return function(ctx)')
      return create_section(ctx)
    end)
    if not ok then
      vim.notify(string.format('Dashboard section %s: %s', path, section_or_err), vim.log.levels.WARN)
    elseif section_or_err then
      table.insert(sections, section_or_err)
    end
  end
  return sections
end

local function dynamic_sections(ctx)
  local sections = require('config.utils').is_work() and { review_requests_section() } or {}
  vim.list_extend(sections, external_sections(ctx))

  local layout = {}
  for _, section in ipairs(sections) do
    vim.list_extend(layout, { { type = 'padding', val = 2 }, section })
  end
  return layout
end

-- Defers creating the group's elements until alpha first draws it, so plain `nvim file` skips the work
local function lazy_group(create_elements)
  local elements
  return {
    type = 'group',
    val = function()
      elements = elements or create_elements()
      return elements
    end,
  }
end

return {
  'goolord/alpha-nvim',
  lazy = false,
  priority = 1100,
  enabled = true,
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = { 'Hi' }

    dashboard.section.buttons.val = {
      aligned_button('s', ' Open session', function()
        MiniSessions.select 'read'
      end),
    }

    local ctx = {
      button = aligned_button,
      text = left_aligned_text,
      truncate = truncate,
      button_width = button_width,
      redraw = redraw,
    }

    dashboard.config.layout = {
      { type = 'padding', val = 2 },
      dashboard.section.header,
      { type = 'padding', val = 2 },
      dashboard.section.buttons,
      lazy_group(function()
        return dynamic_sections(ctx)
      end),
    }

    return dashboard.config
  end,
}
