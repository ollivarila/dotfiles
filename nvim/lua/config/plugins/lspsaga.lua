return {
  'nvimdev/lspsaga.nvim',
  config = function()
    require('lspsaga').setup {
      ui = {},
      hover = {},
      outline = {
        win_position = 'right',
        win_width = 40,
        detail = false,
      },
    }
    require('config.keymaps').lsp_saga()
  end,
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  event = { 'BufAdd', 'InsertEnter' },
}
