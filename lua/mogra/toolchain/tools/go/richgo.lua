local helpers = require("mogra.toolchain.helpers")

return {
  name = "richgo",
  description = "Rich test output for Go",
  install_cmd = "go install -v github.com/kyoh86/richgo@latest",
  update_cmd = "go install -v github.com/kyoh86/richgo@latest",
  is_installed = function()
    return helpers.command_exists("richgo")
  end,
}
