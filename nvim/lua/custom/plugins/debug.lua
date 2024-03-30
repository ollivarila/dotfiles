return {
  'mfussenegger/nvim-dap',
  -- dependencies = {
  --   {
  --     'jay-babu/mason-nvim-dap.nvim',
  --     dependencies = {
  --       'williamboman/mason.nvim',
  --     },
  --     config = function()
  --       local ensure_installed = {}
  --
  --       local handlers = {
  --         function(config)
  --           require('mason-nvim-dap').default_setup(config)
  --         end,
  --       }
  --
  --       require('mason-nvim-dap').setup {
  --         ensure_installed,
  --         handlers,
  --       }
  --     end,
  --   },
  -- },
  config = function()
    local dap = require 'dap'

    --            /home/olli/.local/share/nvim/mason/packages/cpptools/extension/debugAdapters/bin
    local command = vim.fn.stdpath 'data' .. '/mason/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7'
    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command,
    }
    dap.configurations.rust = {
      {
        name = 'Launch file',
        type = 'cppdbg',
        request = 'launch',
        program = function()
          return 'fuck you'
        end,
        -- program = function()
        --   return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        -- end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
      },
      {
        name = 'Attach to gdbserver :1234',
        type = 'cppdbg',
        request = 'launch',
        MIMode = 'gdb',
        miDebuggerServerAddress = 'localhost:1234',
        miDebuggerPath = '/usr/bin/gdb',
        cwd = '${workspaceFolder}',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
      },
    }
  end,
}
