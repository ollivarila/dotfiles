return {
  'folke/trouble.nvim',
  config = function()
    require('trouble').setup {
      position = 'right',
    }
    require('config.keymaps').trouble()
  end,
}
