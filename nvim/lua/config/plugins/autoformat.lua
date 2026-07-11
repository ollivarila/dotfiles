return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = true,
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = false,
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      sql = { 'sql_formatter' },
      json = { 'oxfmt', 'jq' },
      jsonc = { 'oxfmt', 'jq' },
      typescript = { 'oxfmt' },
      typescriptreact = { 'oxfmt' },
      javascript = { 'oxfmt' },
      javascriptreact = { 'oxfmt' },
      css = { 'oxfmt' },
      scss = { 'oxfmt' },
      less = { 'oxfmt' },
      yaml = { 'oxfmt' },
      markdown = { 'oxfmt' },
      nix = { 'nixfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
  },
}
