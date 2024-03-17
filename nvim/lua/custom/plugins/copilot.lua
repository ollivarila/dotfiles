return {
  'github/copilot.vim',
  event = 'InsertEnter',
  config = function()
    require('custom.keymaps').copilot()
  end,
}
