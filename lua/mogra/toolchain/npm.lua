local helpers = require("mogra.toolchain.helpers")
local project_root = require("mogra.projects.finn_web").root

local function has_node(version)
  if not helpers.command_exists "mise" then
    return false
  end
  return vim.system({ "mise", "where", "node@" .. version }, { text = true }):wait().code == 0
end

local function install_command()
  local config = vim.fn.shellescape(vim.fs.joinpath(project_root, ".mise.toml"))
  local root = vim.fn.shellescape(project_root)
  return ("mise trust %s --yes && mise install -C %s && mise install node@20"):format(config, root)
end

return {
  name = "NPM",
  description = "FINN Node.js 22/20 runtimes and npm through mise",
  get_install_cmd = install_command,
  get_update_cmd = install_command,
  is_installed = function()
    return has_node "22" and has_node "20"
  end,
}
