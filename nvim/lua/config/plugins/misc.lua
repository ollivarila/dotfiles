return {
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    -- Only the floating vim.ui.input prompt (e.g. LSP rename); vim.ui.select
    -- is handled by mini.pick, so every other snacks module stays off.
    opts = {
      input = {
        enabled = true,
        win = { relative = 'cursor', row = -3, col = 0 },
      },
    },
  },
}
