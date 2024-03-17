return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {}
    require('custom.keymaps').nvim_tree()
  end,
}
