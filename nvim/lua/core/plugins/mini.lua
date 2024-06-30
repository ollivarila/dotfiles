return { -- Collection of various small independent plugins/modules
  'echasnovski/mini.nvim',
  dependencies = {
    'stevearc/dressing.nvim',
  },
  config = function()
    local keymaps = require 'custom.keymaps'
    -- Better Around/Inside textobjects
    --
    -- Examples:
    --  - va)  - [V]isually select [A]round [)]paren
    --  - yinq - [Y]ank [I]nside [N]ext [']quote
    --  - ci'  - [C]hange [I]nside [']quote
    require('mini.ai').setup { n_lines = 500 }

    -- Add/delete/replace surroundings (brackets, quotes, etc.)
    --
    -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
    -- - sd'   - [S]urround [D]elete [']quotes
    -- - sr)'  - [S]urround [R]eplace [)] [']
    require('mini.surround').setup()

    -- Automatic {} etc
    require('mini.pairs').setup {
      ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a\\].', register = { cr = false } },
    }

    -- Simple tabline
    require('mini.tabline').setup()

    -- Sessions
    require('mini.sessions').setup {
      autoread = false,
      force = {
        delete = true,
      },
    }
    keymaps.mini_sessions()

    -- Simple picker
    require('mini.pick').setup()

    -- File system explorer
    require('mini.files').setup()
    keymaps.mini_files()

    -- Comment lines
    require('mini.comment').setup()
  end,
}
