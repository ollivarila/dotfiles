return {
  'ray-x/lsp_signature.nvim',
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
  opts = {
    hint_prefix = '',
    max_height = 6,
    max_width = 40,
  },
}
