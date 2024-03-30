return {
  'folke/trouble.nvim',
  config = function()
    require('trouble').setup()
    require('custom.keymaps').trouble()
  end,
}
