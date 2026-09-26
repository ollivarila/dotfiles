-- LSP/treesitter breadcrumbs (e.g. mod > my_fn) in the winbar
return {
  'Bekaboo/dropbar.nvim',
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' },
  opts = {},
}
