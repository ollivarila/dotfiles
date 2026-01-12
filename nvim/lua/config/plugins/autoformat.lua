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
      json = { 'jq' },
      typescriptreact = {},
      typescript = {},
      javascript = {},
      javascriptreact = {},
      nix = { 'nixfmt' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
  },
}
