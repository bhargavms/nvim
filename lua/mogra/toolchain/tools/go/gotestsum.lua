local helpers = require("mogra.toolchain.helpers")

return {
  name = "gotestsum",
  description = "Go test runner with better output",
  install_cmd = "go install -v gotest.tools/gotestsum@latest",
  update_cmd = "go install -v gotest.tools/gotestsum@latest",
  is_installed = function()
    return helpers.command_exists("gotestsum")
  end,
}
