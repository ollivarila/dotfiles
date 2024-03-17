-- Cool icons
--            
return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
    config = function()
      vim.g.version_component = {
        current_dir = '',
        version = '',
      }
      local function get_version()
        return vim.g.version_component.version
      end

      local utils = require 'core.utils'
      local Job = require 'plenary.job'

      local function version_job()
        local should_check = utils.should_check_version()
        if should_check == false then
          return
        end

        utils.reassign_cwd()

        local version_command = utils.get_version_command()
        if version_command == nil then
          utils.set_version ''
          return
        end

        Job:new({
          command = version_command,
          args = { '--version' },
          on_exit = function(j, return_val)
            if return_val == 0 then
              local version = j:result()
              local message = utils.format_message(version_command, version[1])
              utils.set_version(message)
            end
          end,
        }):start()
      end

      local timer = vim.loop.new_timer()
      local interval = 1000
      timer:start(1000, interval, vim.schedule_wrap(version_job))

      require('lualine').setup {
        options = {
          icons_enabled = true,
          theme = 'gruvbox',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = false,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          },
        },
        sections = {
          lualine_a = { 'mode' },
          lualine_b = { 'branch', 'diff', 'diagnostics' },
          lualine_c = {},
          lualine_x = {},
          lualine_y = { 'filename', 'filetype', get_version },
          lualine_z = { 'fileformat' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      }
    end,
  },
}
