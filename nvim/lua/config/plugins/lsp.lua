-- This file contains some global configuration related to all lsps
-- and automatic setup & install configuration of lsps
return {
  event = { 'BufAdd', 'InsertEnter' },
  -- Default configurations for many lsps
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Package manager for lsps
    'williamboman/mason.nvim',
    -- Automatic lsp install & setup
    'williamboman/mason-lspconfig.nvim',
    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- lsp config dir configs -> nvim-lspconfig defaults -> mason-lspconfig calls vim.lsp.config and vim.lsp.enable

    local keymaps = require 'config.keymaps'

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
      callback = function(event)
        -- Load lsp keymaps
        keymaps.lsp(event)

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.documentHighlightProvider then
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end,
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

    vim.lsp.config('*', {
      capabilities = capabilities,
    })

    vim.lsp.config('ts_ls', {
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
      end,
    })

    require('mason').setup()

    local ensure_installed = {
      'ts_ls',
      'eslint',
      'tailwindcss',
      'bashls',
      'lua_ls',
      'taplo',
      'stylua',
      -- NOTE: theres are not available to install via `mason-lspconfig` because there is no configuration for that in the `nvim-lspconfig`
      -- 'prettier', -- file formatter for many formats like js
      -- 'jq', -- Json processor
    }

    local utils = require 'config.utils'

    if not utils.is_work() then
      ensure_installed = vim.tbl_extend('force', ensure_installed, {
        'clojure_lsp',
        'nil_ls',
      })
    end

    -- This plugin installs all the listed lsps, configures and enables them
    require('mason-lspconfig').setup {
      ensure_installed = ensure_installed,
    }
  end,
}
