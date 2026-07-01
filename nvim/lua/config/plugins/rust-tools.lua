return {
  'mrcjkb/rustaceanvim',
  version = '^9', -- Recommended
  lazy = false, -- This plugin is already lazy
  config = function()
    -- rustup-distributed rust-analyzer (~/.cargo/bin proxy) lags and panics on
    -- new module files; use the brew-installed standalone binary instead.
    vim.g.rustaceanvim = {
      -- Plugin configuration
      tools = {},
      -- LSP configuration
      server = {
        -- cmd = { '/opt/homebrew/bin/rust-analyzer' },
        on_attach = function(client, bufnr)
          -- you can also put keymaps in here
          vim.keymap.set('n', 'C-<space>', '<Plug>RustHoverAction')
          vim.keymap.set('n', '<leader>do', function()
            vim.cmd.RustLsp 'openDocs'
          end, { desc = 'Open crate documentation on symbol under cursor' })
          vim.keymap.set('n', '<leader>co', function()
            vim.cmd.RustLsp 'openCargo'
          end, { desc = 'Open Cargo.toml' })
        end,
        default_settings = {
          -- rust-analyzer language server configuration
          ['rust-analyzer'] = {},
        },
      },
      -- DAP configuration
      dap = {},
    }
  end,
}
