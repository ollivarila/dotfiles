return {
  {
    'github/copilot.vim',
    config = function()
      require('config.keymaps').copilot()
    end,
    event = 'InsertEnter',
  },
}
