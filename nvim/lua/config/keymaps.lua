local norm = function(keymap, action, desc)
  vim.keymap.set('n', keymap, action, { desc = desc })
end
local utils = require 'config.utils'

local M = {}

function M.defaults()
  norm('<Esc>', '<cmd>nohlsearch<CR>')

  norm('<C-u>', '<C-u>zz')
  norm('<C-d>', '<C-d>zz')

  -- Diagnostic keymaps
  norm('<leader>e', vim.diagnostic.open_float, 'Show diagnostic [E]rror messages')
  norm('<leader>q', vim.diagnostic.setloclist, 'Open diagnostic [Q]uickfix list')

  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  norm('<C-h>', '<C-w><C-h>', 'Move focus to the left window')
  norm('<C-l>', '<C-w><C-l>', 'Move focus to the right window')
  norm('<C-j>', '<C-w><C-j>', 'Move focus to the lower window')
  norm('<C-k>', '<C-w><C-k>', 'Move focus to the upper window')

  -- Resize window
  norm('<left>', [[<cmd>vertical resize +5<cr>]])
  norm('<right>', [[<cmd>vertical resize -5<cr>]])
  norm('<up>', [[<cmd>horizontal resize +2<cr>]])
  norm('<down>', [[<cmd>horizontal resize -2<cr>]])

  -- Lazygit
  norm('<leader>g', '<cmd>LazyGit<cr>', 'Open Lazy[G]it')

  norm('<leader>lo', utils.open_link, 'Open copied link')

  -- Diagnostic navigation
  norm('e]', function()
    vim.diagnostic.jump { count = 1, severity = vim.diagnostic.severity.ERROR }
  end, 'Next error [D]iagnostic')

  norm('e[', function()
    vim.diagnostic.jump { count = -1, severity = vim.diagnostic.severity.ERROR }
  end, 'Previous error [D]iagnostic')

  norm('d]', function()
    vim.diagnostic.jump { count = 1, severity = { min = vim.diagnostic.severity.WARN } }
  end, 'Next [D]iagnostic')

  norm('d[', function()
    vim.diagnostic.jump { count = -1, severity = { min = vim.diagnostic.severity.WARN } }
  end, 'Previous [D]iagnostic')

  vim.api.nvim_create_user_command('BufDelOthers', function()
    local bufs = vim.api.nvim_list_bufs()
    local current_buf = vim.api.nvim_get_current_buf()
    for _, i in ipairs(bufs) do
      if i ~= current_buf then
        vim.api.nvim_buf_delete(i, {})
      end
    end
  end, {})
end

function M.telescope()
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  norm('<leader>fh', builtin.help_tags, '[F]ind [H]elp')
  norm('<leader>fk', builtin.keymaps, '[F]ind [K]eymaps')
  norm('<leader>ff', builtin.find_files, '[F]ind [F]iles')
  norm('<leader>fw', builtin.grep_string, '[F]ind current [W]ord')
  norm('<leader>fg', builtin.live_grep, '[F]ind by [G]rep')
  norm('<leader>f.', builtin.oldfiles, '[F]ind Recent Files ("." for repeat)')
  norm('<leader><leader>', builtin.buffers, 'Find existing buffers')

  -- Open file in vsplit
  norm('<C-right>', function()
    local filename = utils.current_file()
    if filename == 'NvimTree_1' then
      vim.print 'Skill issue...'
      return
    end

    vim.cmd 'vsplit'
    builtin.find_files()
  end, 'Find file and open in vsplit')

  -- Slightly advanced example of overriding default behavior and theme
  norm('<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
      winblend = 10,
      previewer = false,
    })
  end, '[/] Fuzzily search in current buffer')

  -- Also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  norm('<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, '[S]earch [/] in Open Files')

  -- Shortcut for searching your neovim configuration files
  norm('<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, '[S]earch [N]eovim files')
end

function M.lsp(event)
  local map = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
  end

  -- Jump to the definition of the word under your cursor.
  --  This is where a variable was first declared, or where a function is defined, etc.
  --  To jump back, press <C-T>.
  map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

  -- Find references for the word under your cursor.
  map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

  -- Jump to the implementation of the word under your cursor.
  --  Useful when your language has ways of declaring types without an actual implementation.
  map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

  -- Jump to the type of the word under your cursor.
  --  Useful when you're not sure what type a variable is and you want to see
  --  the definition of its *type*, not where it was *defined*.
  map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

  -- Fuzzy find all the symbols in your current document.
  --  Symbols are things like variables, functions, types, etc.
  map('<leader>fs', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

  -- Fuzzy find all the symbols in your current workspace
  --  Similar to document symbols, except searches over your whole project.
  map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- Rename the variable under your cursor
  --  Most Language Servers support renaming across files, etc.
  map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

  -- Execute a code action, usually your cursor needs to be on top of an error
  -- or a suggestion from your LSP for this to activate.
  map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Opens a popup that displays documentation about the word under your cursor
  --  See `:help K` for why this keymap
  map('K', vim.lsp.buf.hover, 'Hover Documentation')
  map('fi', function()
    require('trouble').toggle 'lsp'
  end, 'Open [F][i]nder')
  map('<leader>o', function()
    require('trouble').toggle { mode = 'symbols', focus = false, win = { position = 'right', size = 40 } }
  end, 'Open outline')

  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

function M.nvim_tree()
  local tree_api = require 'nvim-tree.api'

  local toggle_tree = tree_api.tree.toggle

  norm('<leader><tab>', function()
    toggle_tree {
      find_file = true,
    }
  end, '[T]oggle tree')
end

function M.trouble()
  local trouble = require 'trouble'
  norm('<leader>xx', function()
    trouble.toggle 'diagnostics'
  end, 'Toggle Trouble')
end

function M.mini_sessions()
  if MiniSessions == nil then
    vim.print 'mini.sessions is not loaded'
    return
  end

  norm('<leader>so', function()
    MiniSessions.select 'read'
  end, 'Select a [S]ession to load')

  norm('<leader>sc', function()
    vim.ui.input({ prompt = 'Create session:' }, function(input)
      if input == '' or input == nil then
        return
      end

      MiniSessions.write(input)
    end)
  end, '[C]reate a [S]ession')

  norm('<leader>sd', function()
    MiniSessions.select 'delete'
  end, '[D]elete a [S]ession')
end

function M.todo_comments()
  norm('<leader>td', '<cmd>TodoTelescope<cr>', 'Search [T]o[D]os')
end

function M.harpoon()
  local harpoon = require 'harpoon'

  norm('<leader>ha', function()
    harpoon:list():add()
  end, '[A]dd a file to [H]arpoon')

  for i = 1, 6, 1 do
    norm('<leader>' .. i, function()
      harpoon:list():select(i)
    end, 'Navigate to file ' .. i)
  end

  norm('<leader>hm', function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
  end, 'Toggle [H]arpoon [M]enu')
end

function M.clojure()
  norm('<ENTER>', '<leader>emt', 'Evaluate form at mark t') -- for running tests
end

return M
