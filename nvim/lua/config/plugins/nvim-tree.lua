return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {}
    require('config.keymaps').nvim_tree()
  end,
}
