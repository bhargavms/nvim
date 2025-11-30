local helpers = require("mogra.toolchain.helpers")

return {
  name = "gotests",
  description = "Generate Go test boilerplate",
  install_cmd = "go install -v github.com/cweill/gotests/gotests@latest",
  update_cmd = "go install -v github.com/cweill/gotests/gotests@latest",
  is_installed = function()
    return helpers.command_exists("gotests")
  end,
}
