-- ~/.config/nvim/lua/os/detect.lua
local M = {}

function M.get_os_theme()
  local is_macos = vim.fn.has "mac" == 1
  local is_linux = vim.fn.has "unix" == 1 and not is_macos
  local is_windows = vim.fn.has "win32" == 1

  if is_macos then
    -- macOS detection using AppleScript
    local handle = io.popen(
      "osascript -e "
        .. '\'tell application "System Events" '
        .. "to tell appearance preferences "
        .. "to return dark mode' 2>/dev/null"
    )
    if handle then
      local result = handle:read "*a"
      handle:close()
      return result:match "true" and "dark" or "light"
    end
  elseif is_linux then
    -- Linux detection (GNOME)
    local handle = io.popen "gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null"
    if handle then
      local result = handle:read "*a"
      handle:close()
      return result:match "dark" and "dark" or "light"
    end
  elseif is_windows then
    -- Windows detection
    local handle = io.popen(
      'powershell -command "'
        .. "Get-ItemProperty -Path HKCU:\\SOFTWARE\\Microsoft\\Windows\\"
        .. "CurrentVersion\\Themes\\Personalize -Name AppsUseLightTheme | "
        .. 'Select-Object -ExpandProperty AppsUseLightTheme"'
    )
    if handle then
      local result = handle:read "*a"
      handle:close()
      return result:match "0" and "dark" or "light"
    end
  end

  -- Default to dark if detection fails
  return "dark"
end

return M
