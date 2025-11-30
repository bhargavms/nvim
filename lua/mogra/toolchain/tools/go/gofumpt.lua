local helpers = require("mogra.toolchain.helpers")

return {
  name = "gofumpt",
  description = "Stricter gofmt",
  install_cmd = "go install -v mvdan.cc/gofumpt@latest",
  update_cmd = "go install -v mvdan.cc/gofumpt@latest",
  is_installed = function()
    return helpers.command_exists("gofumpt")
  end,
}
