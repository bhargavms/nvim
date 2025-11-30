local helpers = require("mogra.toolchain.helpers")

return {
  name = "impl",
  description = "Generate method stubs for interface implementation",
  install_cmd = "go install -v github.com/josharian/impl@latest",
  update_cmd = "go install -v github.com/josharian/impl@latest",
  is_installed = function()
    return helpers.command_exists("impl")
  end,
}
