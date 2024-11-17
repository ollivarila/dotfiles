local keymaps = require 'config.keymaps'
local options = require 'config.options'
local autocmds = require 'config.autocmds'
-- Load vscode config
if vim.g.vscode then
  keymaps.vscode()
  return
end

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

-- [[ Configure and install plugins ]]
local plugins = utils.get_plugins()
require('lazy').setup(plugins)

vim.cmd 'colorscheme gruvbox'
-- Some plugin messes up with the formatoptions
vim.cmd 'set formatoptions-=cro'
-- vim: ts=2 sts=2 sw=2 et
