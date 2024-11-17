return {
  'goolord/alpha-nvim',
  event = 'VimEnter',
  enabled = true,
  init = false,
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
