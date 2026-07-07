local M = {}

M.current_file = function()
  return vim.fn.expand '%'
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
