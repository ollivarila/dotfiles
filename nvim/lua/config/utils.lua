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

--- Splits a command line into args like a shell: whitespace separates,
--- single/double quotes group (`--name "hello world"` -> `--name`, `hello world`).
---@param str string
---@return string[]
function M.split_args(str)
  local args, current, quote, in_arg = {}, {}, nil, false
  for char in str:gmatch '.' do
    if quote then
      if char == quote then
        quote = nil
      else
        table.insert(current, char)
      end
    elseif char == '"' or char == "'" then
      quote, in_arg = char, true
    elseif char:match '%s' then
      if in_arg then
        table.insert(args, table.concat(current))
        current, in_arg = {}, false
      end
    else
      table.insert(current, char)
      in_arg = true
    end
  end
  if in_arg then
    table.insert(args, table.concat(current))
  end
  return args
end

return M
