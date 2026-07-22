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

    dapui.setup()
    require('nvim-dap-virtual-text').setup()

    -- F-keys fire immediately on press, so which-key can't hint them like it
    -- does for the <leader>d group. Remind on every session start instead.
    local function notify_debug_hints()
      vim.notify(
        table.concat({
          'Debug started',
          '  F5  Continue      S-F5  Terminate',
          '  F9  Breakpoint    F10   Step over',
          '  F11 Step into     S-F11 Step out',
          '  <leader>d for the full keymap group',
        }, '\n'),
        vim.log.levels.INFO
      )
    end

    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
      notify_debug_hints()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
      notify_debug_hints()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end

    -- VSCode-like red breakpoint dot
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DiagnosticWarn' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticOk' })

    -- Defensive: lsp.lua also calls this, but it's lazy-loaded on a
    -- different event, so don't rely on its ordering relative to this file.
    -- mason.setup() is safe to call more than once.
    require('mason').setup()

    -- 'js' is mason-nvim-dap's own alias for the 'js-debug-adapter' mason package
    -- (see mason-nvim-dap/mappings/source.lua) -- ensure_installed takes these
    -- aliases, not raw mason package names.
    require('mason-nvim-dap').setup {
      ensure_installed = { 'js' },
    }

    -- js-debug-adapter (vscode-js-debug) isn't in mason-nvim-dap's built-in
    -- adapter mappings, so wire up the `pwa-node` adapter manually. Resolved
    -- lazily (as a function) since Mason's registry index isn't populated
    -- yet at plugin-config time on a fresh install.
    dap.adapters['pwa-node'] = function(callback, config)
      local install_path = require('mason-registry').get_package('js-debug-adapter'):get_install_path()
      callback {
        type = 'server',
        host = 'localhost',
        port = '${port}',
        executable = {
          command = 'node',
          args = { install_path .. '/js-debug/src/dapDebugServer.js', '${port}' },
        },
      }
    end

    for _, language in ipairs { 'javascript', 'javascriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch file',
          program = '${file}',
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
    end

    -- `${file}` is wrong for TS: node can't run a `.ts` file directly, and
    -- `${file}` resolves to whatever buffer is active, so launching from the
    -- `.ts` source (rather than the compiled output) silently fails with no
    -- breakpoint binding. Prompt for the compiled entry point instead.
    for _, language in ipairs { 'typescript', 'typescriptreact' } do
      dap.configurations[language] = {
        {
          type = 'pwa-node',
          request = 'launch',
          name = 'Launch compiled file',
          program = function()
            return vim.fn.input('Path to compiled entry point: ', vim.fn.getcwd() .. '/dist/', 'file')
          end,
          cwd = '${workspaceFolder}',
        },
        {
          type = 'pwa-node',
          request = 'attach',
          name = 'Attach to process',
          processId = require('dap.utils').pick_process,
          cwd = '${workspaceFolder}',
        },
      }
    end

    require('config.keymaps').dap()
  end,
}
