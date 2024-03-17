return {
  'luozhiya/lsp-virtual-improved.nvim',
  event = { 'LspAttach' },
  config = function()
    require('lsp-virtual-improved').setup()
    local diagnostics = {
      virtual_text = false, -- Disable builtin virtual text diagnostic.
      virtual_improved = {
        current_line = 'only',
      },
    }
    vim.diagnostic.config(diagnostics)
  end,
  enabled = false,
}
