return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'theHamsta/nvim-dap-virtual-text',
    'jay-babu/mason-nvim-dap.nvim',
    'mason-org/mason.nvim',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    dapui.setup {
      layouts = {
        {
          position = 'left',
          size = 40,
          elements = {
            { id = 'scopes', size = 0.75 },
            { id = 'breakpoints', size = 0.25 },
          },
        },
      },
    }
    require('nvim-dap-virtual-text').setup()

    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close

    -- VSCode-like breakpoint signs
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk' })

    -- mason.setup() is idempotent; lsp.lua also calls it but may load later.
    require('mason').setup()
    -- Only used for installing. Rust adapter + configurations are set up by
    -- rustaceanvim once codelldb is installed; js-debug is wired up below.
    require('mason-nvim-dap').setup { ensure_installed = { 'js', 'codelldb' } }

    -- vscode-js-debug; the mason `js-debug-adapter` bin wraps dapDebugServer.js.
    -- `node`/`chrome` are the type names VSCode launch.json files use.
    for _, type in ipairs { 'node', 'chrome' } do
      local adapter = {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = { command = 'js-debug-adapter', args = { '${port}' } },
        enrich_config = function(config, on_config)
          on_config(vim.tbl_extend('force', config, { type = 'pwa-' .. type }))
        end,
      }
      dap.adapters[type] = adapter
      dap.adapters['pwa-' .. type] = adapter
    end

    require('config.keymaps').dap()
  end,
}
