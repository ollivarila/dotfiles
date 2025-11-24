return {
  'Olical/conjure',
  {
    'clojure-vim/vim-jack-in',
    dependencies = {
      'tpope/vim-dispatch',
    },
  },
  -- 'luochen1990/rainbow',
  -- 'HiPhish/rainbow-delimiters.nvim',
  {

    'tpope/vim-sexp-mappings-for-regular-people',
    dependencies = {
      'guns/vim-sexp',
    },
  },
  ft = { 'clojure' },
  config = function()
    require('config.keymaps').clojure()
  end,
  enabled = false,
}
