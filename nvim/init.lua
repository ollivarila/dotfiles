local keymaps = require 'config.keymaps'
local options = require 'config.options'
local autocmds = require 'config.autocmds'

local utils = require 'config.utils'

-- NOTE: Default settings contain settings that are plugin agnostic
-- They also might need to be loaded before any plugins

-- Load default options
options.defaults()
-- Load default keymaps
keymaps.defaults()
-- Load default autocmds
autocmds.defaults()

-- Setup lazy.nvim plugin manager
require 'config.setup_lazy'()

-- Configure and install plugins
local plugins = utils.get_plugins()

require('lazy').setup(plugins)

vim.cmd 'colorscheme gruvbox'
