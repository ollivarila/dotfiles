local enable_clojure = false

return {
  {
    'Olical/conjure',
    enabled = enable_clojure,
    ft = { 'clojure' },
    config = function()
      require('config.keymaps').clojure()
    end,
  },
  {
    'clojure-vim/vim-jack-in',
    enabled = enable_clojure,
    dependencies = {
      'tpope/vim-dispatch',
    },
  },
  {
    'tpope/vim-sexp-mappings-for-regular-people',
    enabled = enable_clojure,
    dependencies = {
      'guns/vim-sexp',
    },
  },
}
