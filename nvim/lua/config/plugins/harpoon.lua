return {
  'ThePrimeagen/harpoon',
  branch = 'harpoon2',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    require('harpoon'):setup()
    require('config.keymaps').harpoon()
  end,
  event = { 'BufAdd', 'InsertEnter' },
}
