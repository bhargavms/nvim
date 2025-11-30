local helpers = require("mogra.toolchain.helpers")

return {
  name = "mockgen",
  description = "Go mock generator",
  install_cmd = "go install -v go.uber.org/mock/mockgen@latest",
  update_cmd = "go install -v go.uber.org/mock/mockgen@latest",
  is_installed = function()
    return helpers.command_exists("mockgen")
  end,
}
