local helpers = require("mogra.toolchain.helpers")

return {
  name = "gopls",
  description = "Go language server",
  install_cmd = "go install -v golang.org/x/tools/gopls@latest",
  update_cmd = "go install -v golang.org/x/tools/gopls@latest",
  is_installed = function()
    return helpers.command_exists("gopls")
  end,
}
