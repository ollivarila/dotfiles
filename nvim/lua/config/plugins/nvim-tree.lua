return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup {
      filters = {
        dotfiles = false,
      },
    }
    require('config.keymaps').nvim_tree()
  end,
}
