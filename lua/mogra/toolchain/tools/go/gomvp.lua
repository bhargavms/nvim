local helpers = require("mogra.toolchain.helpers")

return {
  name = "gomvp",
  description = "Go package renaming tool",
  install_cmd = "go install -v golang.org/x/tools/cmd/gomvpkg@latest",
  update_cmd = "go install -v golang.org/x/tools/cmd/gomvpkg@latest",
  is_installed = function()
    return helpers.command_exists("gomvpkg")
  end,
}
