local keymaps = require 'config.keymaps'
local options = require 'config.options'
local autocmds = require 'config.autocmds'

local utils = require 'config.utils'

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
