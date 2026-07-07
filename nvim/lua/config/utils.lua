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
  local custom_plugins = {
    { import = 'config.plugins' },
  }

  return custom_plugins
end

function M.is_work()
  return os.getenv 'WORK' == 'true'
end

function M.open_link()
  local url = vim.fn.getreg '"'

  if url == '' then
    return
  end

  -- Detect OS and open the URL
  local open_cmd
  if vim.fn.has 'mac' == 1 then
    open_cmd = 'open'
  elseif vim.fn.has 'unix' == 1 then
    open_cmd = 'xdg-open'
  else
    print 'Unsupported OS'
    return
  end

  -- Run the command
  os.execute(string.format('%s "%s"', open_cmd, url))
end

return M
