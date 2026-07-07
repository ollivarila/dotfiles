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
        -- cmp-nvim-lsp's default_capabilities disables didChangeWatchedFiles
        -- dynamicRegistration, which makes rust-analyzer fall back to its own
        -- recursive file walker and crawl huge dirs (node_modules, nixpkgs via
        -- .direnv). Re-enable so the editor handles watching instead.
        capabilities = {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        },
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
          ['rust-analyzer'] = {
            files = {
              -- Keep r-a out of non-source trees so it doesn't crawl huge dirs
              -- (e.g. node_modules, .direnv/nixpkgs) and stall on indexing.
              excludeDirs = {
                '_build',
                '.dart_tool',
                '.flatpak-builder',
                '.git',
                '.gitlab',
                '.gitlab-ci',
                '.gradle',
                '.idea',
                '.next',
                '.project',
                '.scannerwork',
                '.settings',
                '.venv',
                'archetype-resources',
                'bin',
                'hooks',
                'node_modules',
                'po',
                'screenshots',
                'target',
              },
            },
            cargo = {
              -- Give r-a its own check target dir so its cache is not
              -- invalidated by CLI `cargo build`/cross-target artifacts;
              -- warms once and stays warm across edits.
              targetDir = true,
            },
          },
        },
      },
      -- DAP configuration
      dap = {},
    }
  end,
}
