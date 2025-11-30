local helpers = require("mogra.toolchain.helpers")

return {
  name = "fillswitch",
  description = "Fill switch statements with case clauses",
  install_cmd = "go install -v github.com/davidrjenni/reftools/cmd/fillswitch@latest",
  update_cmd = "go install -v github.com/davidrjenni/reftools/cmd/fillswitch@latest",
  is_installed = function()
    return helpers.command_exists("fillswitch")
  end,
}
