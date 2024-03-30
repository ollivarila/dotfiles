local M = {}

M.current_file = function()
  return vim.fn.expand '%'
end

M.args = function()
  return vim.v.argv
end

M.empty_filename = function()
  local file = M.current_file()
  local t = type(file)
  -- print 'type of current file:'
  -- print(t)
  if t == 'string' and file == '' then
    return true
  end

  return file == nil
end

M.pick_session_if_empty_file = function()
  if MiniPick == nil then
    vim.print 'mini.pick is not loaded, cannot pick session'
    return
  end

  if MiniSessions == nil then
    vim.print 'mini.sessions is not loaded, cannot pick session'
    return
  end

  local should_pick_session = M.empty_filename()
  if should_pick_session ~= true then
    return
  end

  local sessions = MiniSessions.detected
  local session_names = {}

  for key, _ in pairs(sessions) do
    table.insert(session_names, key)
  end

  local selected_session = MiniPick.start {
    source = {
      name = 'Pick a session:',
      items = session_names,
    },
  }

  if selected_session == nil then
    return
  end

  MiniSessions.read(selected_session)
end

function M.get_plugins()
  -- Merge core and custom plugins
  local plugins = require 'core'
  local custom_plugins = {
    -- require 'kickstart.plugins.debug',
    require 'kickstart.plugins.indent_line',
    { import = 'custom.plugins' },
  }

  for _, value in pairs(custom_plugins) do
    table.insert(plugins, value)
  end

  return plugins
end

function M.get_version_command()
  local scan = require 'plenary.scandir'
  local scanned = scan.scan_dir('.', {
    hidden = true,
    depth = 1,
    search_pattern = {
      'package.json',
      'Cargo.toml',
    },
  })

  if scanned == nil then
    return nil
  end

  for _, value in pairs(scanned) do
    if value:find 'package.json' then
      return 'node'
    end

    if value:find 'Cargo.toml' then
      return 'rustc'
    end
  end

  return nil
end

function M.format_message(version_command, output)
  if version_command == 'node' then
    return output
  end

  if version_command == 'rustc' then
    -- split by space
    -- get the second element
    local parts = vim.split(output, ' ')
    if parts[1] == 'rustc' then
      return 'v' .. parts[2]
    end
  end

  return ''
end

function M.should_check_version()
  local current_dir = vim.g.version_component.current_dir
  if current_dir == '' then
    return true
  end

  if current_dir ~= vim.fn.getcwd() then
    return true
  end

  return false
end

function M.reassign_cwd()
  local version_component = vim.g.version_component
  version_component.current_dir = vim.fn.getcwd()
  vim.g.version_component = version_component
end

function M.set_version(version)
  local version_component = vim.g.version_component
  version_component.version = version
  vim.g.version_component = version_component
end

return M
