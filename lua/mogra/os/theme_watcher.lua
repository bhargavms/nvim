-- ~/.config/nvim/lua/os/theme_watcher.lua
local M = {}
local detect = require('mogra.os.detect')

function M.setup(theme_callback)
  -- Store initial theme
  local current_theme = detect.get_os_theme()

  -- Initial theme setup
  theme_callback(current_theme)

  -- Set up autocmd to check for theme changes (every 5 minutes)
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      vim.fn.timer_start(300000, function() -- 5 minutes
        local new_theme = detect.get_os_theme()
        if new_theme ~= current_theme then
          current_theme = new_theme
          theme_callback(current_theme)
        end
      end, {['repeat'] = -1})
    end
  })
end

return M
