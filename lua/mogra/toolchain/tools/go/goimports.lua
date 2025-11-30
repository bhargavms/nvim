local helpers = require("mogra.toolchain.helpers")

return {
  name = "goimports",
  description = "Go imports management tool",
  install_cmd = "go install -v golang.org/x/tools/cmd/goimports@latest",
  update_cmd = "go install -v golang.org/x/tools/cmd/goimports@latest",
  is_installed = function()
    return helpers.command_exists("goimports")
  end,
}
