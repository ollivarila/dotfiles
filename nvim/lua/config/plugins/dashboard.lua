return {
  'goolord/alpha-nvim',
  lazy = false,
  priority = 1100,
  enabled = true,
  opts = function()
    local dashboard = require 'alpha.themes.dashboard'

    dashboard.section.header.val = {
      '   _   ______     _______________    ____ ',
      '  / | / / __ \\   / ____/ ____/   |  / __ \\',
      ' /  |/ / / / /  / /_  / __/ / /| | / /_/ /',
      '/ /|  / /_/ /  / __/ / /___/ ___ |/ _, _/ ',
      '/_/ |_/\\____/  /_/   /_____/_/  |_/_/ |_|',
    }

    dashboard.section.buttons.val = {
      dashboard.button('s', ' Open session', function()
        MiniSessions.select 'read'
      end),
    }

    local messages = {
      'We shall fix it in the frontend, we shall fix it in the backend, we shall never surrender to the null pointer. — Winston Churchill',
      'Never in the field of software engineering was so much broken by so few lines of code. — Winston Churchill',
      'Success is going from bug to bug with no loss of enthusiasm. — Churchill, probably',
      'This is not the end of the sprint. It is not even the beginning of the end. It is, perhaps, the end of the beginning of standup. — Winston Churchill',
      'History will be kind to this deploy, for I intend to write the postmortem. — Winston Churchill',
      'We make a living by what we ship. We make a life by what we refactor. — Winston Churchill',
    }
    math.randomseed(os.time())
    dashboard.section.footer.val = messages[math.random(#messages)]

    return dashboard.config
  end,
}
