return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`

    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter.configs').setup {
      ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'rust', 'markdown_inline' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
    }
    local ft_to_lang = require('nvim-treesitter.parsers').ft_to_lang
    require('nvim-treesitter.parsers').ft_to_lang = function(ft)
      if ft == 'zsh' then
        return 'bash'
      end
      return ft_to_lang(ft)
    end
  end,
}
