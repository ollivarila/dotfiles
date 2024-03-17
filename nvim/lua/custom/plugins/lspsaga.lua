return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {}
    require('custom.keymaps').lsp_saga()
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
}
