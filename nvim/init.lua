local keymaps = require 'custom.keymaps'
local options = require 'custom.options'
local autocmds = require 'custom.autocmds'
-- Load vscode config
if vim.g.vscode then
  keymaps.vscode()
  return
end

local utils = require 'core.utils'

-- NOTE: Default settings contain settings that are plugin agnostic
-- They also might need to be loaded before any plugins

-- Load default options
options.defaults()
-- Load default keymaps
keymaps.defaults()
-- Load default autocmds
autocmds.defaults()

-- Setup lazy.nvim
require 'core.setup_lazy'()

-- [[ Configure and install plugins ]]
local plugins = utils.get_plugins()
require('lazy').setup(plugins)

-- Pick session if nvim started with no args
utils.pick_session_if_empty_file()

-- Some plugin messes up with the formatoptions
vim.cmd 'set formatoptions-=cro'
-- vim: ts=2 sts=2 sw=2 et
