return {
  'folke/trouble.nvim',
  config = function()
    require('trouble').setup {
      position = 'right',
    }
    require('custom.keymaps').trouble()
  end,
}
