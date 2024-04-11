return {
  'github/copilot.vim',
  config = function()
    require('custom.keymaps').copilot()
  end,
  event = 'VeryLazy',
}
