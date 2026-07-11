return { -- Highlight, edit, and navigate code
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,
  config = function()
    local ensure_installed =
      { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'rust', 'markdown_inline', 'zsh', 'typescript', 'tsx', 'javascript', 'json' }
    require('nvim-treesitter').install(ensure_installed)

    local utils = require 'config.utils'
    if not utils.is_work() then
      vim.api.nvim_create_autocmd('User', {
        pattern = 'TSUpdate',
        callback = function()
          require('nvim-treesitter.parsers').foo = {
            install_info = {
              path = '/home/olli/code/rust/foolang/tree-sitter-foo',
              queries = 'queries/foo',
            },
          }
        end,
      })
    end

    -- highlight/indent: use Neovim core instead of the old configs.setup API
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        if pcall(vim.treesitter.start) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
