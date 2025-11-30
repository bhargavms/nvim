local helpers = require("mogra.toolchain.helpers")

return {
  name = "dlv",
  description = "Delve debugger for Go",
  install_cmd = "go install -v github.com/go-delve/delve/cmd/dlv@latest",
  update_cmd = "go install -v github.com/go-delve/delve/cmd/dlv@latest",
  is_installed = function()
    return helpers.command_exists("dlv")
  end,
}
