local helpers = require("mogra.toolchain.helpers")

return {
  name = "gomodifytags",
  description = "Modify Go struct field tags",
  install_cmd = "go install -v github.com/fatih/gomodifytags@latest",
  update_cmd = "go install -v github.com/fatih/gomodifytags@latest",
  is_installed = function()
    return helpers.command_exists("gomodifytags")
  end,
}
