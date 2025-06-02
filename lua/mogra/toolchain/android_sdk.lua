local M = {}
local helpers = require("mogra.toolchain.helpers")

M.name = "Android SDK"
M.description = "Android SDK command-line tools (macOS)"

local sdk_dir = os.getenv("HOME") .. "/Library/Android/sdk"
local shell_rc = os.getenv("HOME") .. "/.zshrc"

local function ensure_ok(ok, msg)
  if not ok then error(msg) end
end

function M.is_installed()
  return helpers.command_exists("sdkmanager") and vim.fn.isdirectory(sdk_dir) == 1
end

function M.install()
  local sdk_version = helpers.read_toolchain_version("android_sdk_cmdline_tools")
  vim.notify("Installing Android SDK cmdline tools version " .. sdk_version .. "...", vim.log.levels.INFO)
  local temp_dir = os.getenv("HOME") .. "/.local/tmp/android-sdk-install"
  ensure_ok(os.execute("mkdir -p " .. temp_dir), "Failed to create temp dir")
  ensure_ok(os.execute("mkdir -p " .. sdk_dir), "Failed to create sdk dir")
  local url = "https://dl.google.com/android/repository/commandlinetools-mac-" .. sdk_version .. "_latest.zip"
  ensure_ok(os.execute("cd " .. temp_dir .. " && curl -LO " .. url), "Failed to download Android SDK cmdline tools")
  ensure_ok(os.execute("cd " .. temp_dir .. " && unzip -o commandlinetools-mac-" .. sdk_version .. "_latest.zip -d " .. sdk_dir .. "/cmdline-tools"), "Failed to unzip Android SDK cmdline tools")
  ensure_ok(os.execute("mkdir -p '" .. sdk_dir .. "/cmdline-tools/latest'"), "Failed to create latest dir")
  ensure_ok(os.execute("mv '" .. sdk_dir .. "/cmdline-tools/cmdline-tools'/* '" .. sdk_dir .. "/cmdline-tools/latest/'"), "Failed to move cmdline tools to latest")
  helpers.append_line_if_missing(shell_rc, "export ANDROID_SDK_ROOT=" .. sdk_dir)
  helpers.append_line_if_missing(shell_rc, "export PATH=$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools")
  ensure_ok(os.execute("rm -rf " .. temp_dir), "Failed to clean up temp dir")
  vim.notify("Android SDK installation complete! Please run 'source ~/.zshrc' to update your environment", vim.log.levels.SUCCESS)
end

function M.update()
  ensure_ok(os.execute("sdkmanager --update"), "Failed to update Android SDK")
  vim.notify("Android SDK update complete!", vim.log.levels.SUCCESS)
end

return M
