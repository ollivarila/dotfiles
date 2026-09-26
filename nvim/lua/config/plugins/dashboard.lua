return {
  'goolord/alpha-nvim',
  lazy = false,
  priority = 1100,
  enabled = true,
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = { 'Hi' }

    dashboard.section.buttons.val = {
      dashboard.button('s', ' Open session', function()
        MiniSessions.select 'read'
      end),
    }

    local prs = { 'Loading review requests…' }
    dashboard.section.footer.val = function()
      return prs
    end

    local cmd = {
      'gh', 'search', 'prs',
      '--review-requested', 'ollivarila',
      '--state', 'open',
      '--limit', '10',
      '--json', 'repository,number,title',
      '--jq', '.[] | "\\(.repository.nameWithOwner)#\\(.number) \\(.title)"',
    }
    vim.system(cmd, { text = true, timeout = 5000 }, function(res)
      vim.schedule(function()
        local out = vim.trim(res.stdout or '')
        if res.code ~= 0 then
          prs = {}
        elseif out == '' then
          prs = { 'No review requests' }
        else
          prs = vim.split(out, '\n')
        end
        if vim.bo.filetype == 'alpha' then
          require('alpha').redraw()
        end
      end)
    end)

    return dashboard.config
  end,
}
