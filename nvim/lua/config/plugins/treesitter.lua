return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    'nvim-treesitter/playground',
  },
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'rust', 'markdown_inline' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
    local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
    local utils = require 'config.utils'
    if not utils.is_work() then
      ---@diagnostic disable-next-line: inject-field
      require('nvim-treesitter.parsers').get_parser_configs().foo = {
        install_info = {
          url = '/home/olli/code/rust/foolang/tree-sitter-foo',
          path = '/home/olli/code/rust/foolang/tree-sitter-foo',
          files = { 'src/parser.c' },
          queries = 'queries/foo',
        },
        filetype = 'foo',
      }
    end

    ---@diagnostic disable-next-line: duplicate-set-field
    require('nvim-treesitter.parsers').ft_to_lang = function(ft)
      if ft == 'zsh' then
        return 'bash'
      end
      return ft_to_lang(ft)
    end
  end,
  lazy = false,
}
