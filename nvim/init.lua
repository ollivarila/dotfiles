local keymaps = require 'config.keymaps'
local options = require 'config.options'
local autocmds = require 'config.autocmds'

local utils = require 'config.utils'

-- FIXME: deprecated/aging config to modernize (nvim 0.12):
-- FIXME: [1] vim.highlight.on_yank() deprecated -> vim.hl.on_yank() (autocmds.lua:42)
-- FIXME: [2] vim.loop soft-deprecated -> vim.uv (setup_lazy.lua:433, lualine.lua:1103)
-- FIXME: [3] mason repos moved to mason-org/; williamboman/* archived (lsp.lua:950-952)
-- FIXME: [4] nvim-treesitter/playground archived -> use built-in :Inspect / :InspectTree (treesitter.lua:1517)
-- FIXME: [5] nvim-treesitter master branch legacy; main branch is 0.11+ rewrite, new API (treesitter.lua:1522)
-- FIXME: [6] dressing.nvim maintenance-only + loaded twice; vim.ui/mini/snacks cover it (misc.lua:1267, mini.lua:1216)
-- FIXME: [7] harpoon v1 API (harpoon.mark/harpoon.ui) -> harpoon2 (keymaps.lua:301)
-- FIXME: [10] nvim-treesitter archived; migrate to built-in treesitter highlight/indent, keep only for grammar installs (treesitter.lua)

-- NOTE: Default settings contain settings that are plugin agnostic
-- They also might need to be loaded before any plugins

-- NOTE: jq and eslint lsps are not installed automatically

-- Load default options
options.defaults()
-- Load default keymaps
keymaps.defaults()
-- Load default autocmds
autocmds.defaults()

require 'config.setup_lazy'()
local plugins = utils.get_plugins()
require('lazy').setup(plugins)

vim.cmd 'colorscheme gruvbox'
