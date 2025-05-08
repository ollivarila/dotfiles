return {
  'goolord/alpha-nvim',
  lazy = false,
  priority = 1100,
  enabled = true,
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.buttons.val = {
      dashboard.button('s', ' Open session', function()
        MiniSessions.select 'read'
      end),
    }

    return dashboard.config
  end,
}
