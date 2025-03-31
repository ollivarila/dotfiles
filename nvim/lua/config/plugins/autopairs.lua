return {
  'windwp/nvim-autopairs',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.cond'
  end,
  enabled = false,
}
