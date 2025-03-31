return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {
      ui = {},
      hover = {},
    }
    require('config.keymaps').lsp_saga()
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  enabled = true,
}
