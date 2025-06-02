local M = {}
local helpers = require("mogra.toolchain.helpers")

M.name = "Java (SDKMAN)"
M.description = "Java JDK via SDKMAN!"

local sdkman_dir = os.getenv("HOME") .. "/.sdkman"
local shell_rc = os.getenv("HOME") .. "/.zshrc"

local function ensure_ok(ok, msg)
  if not ok then error(msg) end
end

function M.is_installed()
  if not helpers.command_exists("java") then return false end
  if vim.fn.isdirectory(sdkman_dir) == 0 then return false end
  return true
end

function M.install()
  local java_version = helpers.read_toolchain_version("java")
  vim.notify("Installing Java " .. java_version .. " via SDKMAN...", vim.log.levels.INFO)
  if vim.fn.isdirectory(sdkman_dir) == 0 then
    ensure_ok(os.execute("curl -s 'https://get.sdkman.io' | bash"), "Failed to install SDKMAN")
    helpers.append_line_if_missing(shell_rc, "export SDKMAN_DIR=\"$HOME/.sdkman\"")
    helpers.append_line_if_missing(shell_rc, "[[ -s \"$HOME/.sdkman/bin/sdkman-init.sh\" ]] && source \"$HOME/.sdkman/bin/sdkman-init.sh\"")
    error("SDKMAN installed. Please run 'source ~/.zshrc' and re-run the install.")
  end
  ensure_ok(os.execute("source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java " .. java_version), "Failed to install Java " .. java_version)
  helpers.append_line_if_missing(shell_rc, "export JAVA_HOME=\"$(sdk env | grep JAVA_HOME | cut -d'=' -f2)\"")
  vim.notify("Java " .. java_version .. " installation complete! Please run 'source ~/.zshrc' to update your environment", vim.log.levels.SUCCESS)
end

function M.update()
  local java_version = helpers.read_toolchain_version("java")
  if vim.fn.isdirectory(sdkman_dir) == 0 then
    error("SDKMAN is not installed. Please run the install first.")
  end
  ensure_ok(os.execute("source $HOME/.sdkman/bin/sdkman-init.sh && sdk install java " .. java_version), "Failed to update Java " .. java_version)
  vim.notify("Java (SDKMAN) update complete!", vim.log.levels.SUCCESS)
end

return M
