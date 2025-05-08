return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function(opts)
    local npairs = require 'nvim-autopairs'
    npairs.setup(opts)
    npairs.remove_rule "'"
    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    local skip_rust_lifetime =
      Rule("'", "'", 'rust'):with_pair(cond.not_before_text '<'):with_pair(cond.not_before_text '&'):with_pair(cond.not_before_text ', ')

    npairs.add_rule(skip_rust_lifetime)
    npairs.add_rule(Rule("'", "'"):with_pair(cond.not_filetypes { 'rust' }))
  end,
  enabled = true,
}
