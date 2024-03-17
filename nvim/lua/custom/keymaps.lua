local norm = function(keymap, action, desc)
  vim.keymap.set('n', keymap, action, { desc = desc })
end

local M = {}

function M.vscode()
  -- FIXME: not working rn
  -- vim.keymap.set('n', '<C-u>', '<C-u>zz')
  -- vim.keymap.set('n', '<C-d>', '<C-d>zz')

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
end

function M.defaults()
  -- Edit config
  vim.keymap.set('n', '<leader>co', function()
    vim.cmd 'cd ~/.config/nvim'
    vim.cmd 'e ~/.config/nvim/init.lua'
  end)

  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  vim.keymap.set('n', '<C-u>', '<C-u>zz')
  vim.keymap.set('n', '<C-d>', '<C-d>zz')

  -- Diagnostic keymaps
  -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
  -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

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
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Resize window
  vim.keymap.set('n', '<left>', [[<cmd>vertical resize +5<cr>]])
  vim.keymap.set('n', '<right>', [[<cmd>vertical resize -5<cr>]])
  vim.keymap.set('n', '<up>', [[<cmd>horizontal resize +2<cr>]])
  vim.keymap.set('n', '<down>', [[<cmd>horizontal resize -2<cr>]])

  -- Lazygit
  vim.keymap.set('n', '<leader>g', '<cmd>LazyGit<cr>', { desc = 'Open Lazy[G]it' })

  -- Open bunch of stuff
  norm('<leader>nla', '<cmd>Lazy<cr>', 'Open [L][A]zy')
  norm('<leader>nma', '<cmd>Mason<cr>', 'Open [M][A]son')
  norm('<leader>nls', '<cmd>LspInfo<cr>', 'Open [L][S]pInfo')

  -- Change buffers
  norm('<leader>l', '<cmd>bNext<cr>', 'Next buffer')
  norm('<leader>h', '<cmd>bprevious<cr>', 'Previous buffer')

  -- Delete buffer
  norm('<leader>dd', '<cmd>bdelete<cr>', 'Delete buffer')
end

function M.telescope()
  -- See `:help telescope.builtin`
  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
  vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [K]eymaps' })
  vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
  -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
  vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
  -- vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  -- vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>f.', builtin.oldfiles, { desc = '[F]ind Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find existing buffers' })

  -- Open file in vsplit
  vim.keymap.set('n', '<C-right>', function()
    local utils = require 'core.utils'
    local filename = utils.current_file()
    if filename == 'NvimTree_1' then
      vim.print 'Skill issue...'
      return
    end

    vim.cmd 'vsplit'
    builtin.find_files()
  end, { desc = 'Find file and open in vsplit' })

  -- Slightly advanced example of overriding default behavior and theme
  vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    builtin.current_buffer_fuzzy_find(require('telescope.themes').get_ivy {
      winblend = 10,
      previewer = false,
    })
  end, { desc = '[/] Fuzzily search in current buffer' })

  -- Also possible to pass additional configuration options.
  --  See `:help telescope.builtin.live_grep()` for information about particular keys
  vim.keymap.set('n', '<leader>s/', function()
    builtin.live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end, { desc = '[S]earch [/] in Open Files' })

  -- Shortcut for searching your neovim configuration files
  vim.keymap.set('n', '<leader>sn', function()
    builtin.find_files { cwd = vim.fn.stdpath 'config' }
  end, { desc = '[S]earch [N]eovim files' })
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
  map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

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

  -- WARN: This is not Goto Definition, this is Goto Declaration.
  --  For example, in C this would take you to the header
  map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
end

function M.nvim_tree()
  local tree_api = require 'nvim-tree.api'

  local toggle_tree = tree_api.tree.toggle

  vim.keymap.set('n', '<leader>t', function()
    toggle_tree {
      find_file = true,
    }
  end, { desc = '[T]oggle tree' })
end

function M.lsp_saga()
  local diagnostic = require 'lspsaga.diagnostic'
  local error_opts = {
    severity = vim.diagnostic.severity.ERROR,
  }
  local diag_opts = {
    severity = { min = vim.diagnostic.severity.WARN },
  }

  norm('e]', function()
    diagnostic:goto_next(error_opts)
  end, 'Next error [D]iagnostic')

  norm('e[', function()
    diagnostic:goto_prev(error_opts)
  end, 'Previous error [D]iagnostic')

  norm('d]', function()
    diagnostic:goto_next(diag_opts)
  end, 'Next [D]iagnostic')

  norm('d[', function()
    diagnostic:goto_prev(diag_opts)
  end, 'Previous [D]iagnostic')
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

function M.mini_files()
  if MiniFiles == nil then
    vim.print 'mini.files is not loaded'
    return
  end

  norm('<leader>mf', function()
    MiniFiles.open()
  end, 'Open [M]ini [F]iles')
end

function M.harpoon()
  local add_file = require('harpoon.mark').add_file
  local ui = require 'harpoon.ui'

  norm('<leader>ha', add_file, '[A]dd a file to [H]arpoon')

  for i = 1, 6, 1 do
    norm('<leader>' .. i, function()
      ui.nav_file(i)
    end, 'Navigate to file ' .. i)
  end

  norm('<leader>hm', ui.toggle_quick_menu, 'Toggle [H]arpoon [M]enu')
end

function M.copilot()
  vim.g.copilot_enabled = 1

  norm('<leader>ct', function()
    local enabled = vim.g.copilot_enabled == 1
    vim.g.copilot_enabled = not enabled
    local cmd = enabled and 'disable' or 'enable'

    vim.cmd('Copilot ' .. cmd)
    vim.notify('Copilot ' .. cmd .. 'd')
  end, '[T]oggle [C]opilot')
end

return M
