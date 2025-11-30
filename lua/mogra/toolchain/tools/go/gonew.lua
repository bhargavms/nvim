local helpers = require("mogra.toolchain.helpers")

return {
  name = "gonew",
  description = "Create new Go modules from templates",
  install_cmd = "go install -v golang.org/x/tools/cmd/gonew@latest",
  update_cmd = "go install -v golang.org/x/tools/cmd/gonew@latest",
  is_installed = function()
    return helpers.command_exists("gonew")
  end,
}
