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
    -- rustaceanvim once codelldb is installed; JS/TS is wired up below.
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

    -- .vscode/launch.json is read automatically on dap.continue(). nvim-dap
    -- already skips comments; also tolerate VSCode-style trailing commas.
    require('dap.ext.vscode').json_decode = function(str, opts)
      return vim.json.decode(str:gsub(',(%s*[%]}])', '%1'), opts)
    end

    -- Picks the package manager from the nearest lockfile (yarn at work, pnpm at home)
    local function package_manager()
      local lockfiles = { ['pnpm-lock.yaml'] = 'pnpm', ['yarn.lock'] = 'yarn', ['bun.lock'] = 'bun' }
      local found = vim.fs.find(vim.tbl_keys(lockfiles), { upward = true, path = vim.fn.getcwd() })[1]
      return found and lockfiles[vim.fs.basename(found)] or 'npm'
    end

    local js_configurations = {
      {
        -- js-debug auto-attaches to the server process `next dev` spawns
        type = 'pwa-node',
        request = 'launch',
        name = 'Next.js: server',
        program = '${workspaceFolder}/node_modules/next/dist/bin/next',
        args = { 'dev' },
        cwd = '${workspaceFolder}',
        skipFiles = { '<node_internals>/**' },
      },
      {
        -- Start `next dev` (or the server config above) first
        type = 'pwa-chrome',
        request = 'launch',
        name = 'Next.js: client',
        url = 'http://localhost:3000',
        webRoot = '${workspaceFolder}',
      },
      {
        -- Generic TS/JS servers, e.g. a `dev` script running `tsx watch src/index.ts`.
        -- js-debug follows child processes, so wrappers like tsx/nodemon work.
        type = 'pwa-node',
        request = 'launch',
        name = 'Run package.json script',
        runtimeExecutable = package_manager,
        runtimeArgs = function()
          return { 'run', vim.fn.input('Script: ', 'dev') }
        end,
        cwd = '${workspaceFolder}',
        console = 'integratedTerminal',
        skipFiles = { '<node_internals>/**', '**/node_modules/**' },
      },
      {
        -- Node >= 22.18 strips TS types natively, so this works for .ts too
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
    for _, language in ipairs { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' } do
      dap.configurations[language] = js_configurations
    end

    require('config.keymaps').dap()
  end,
}
