local helpers = require("mogra.toolchain.helpers")

return {
  name = "golangci-lint",
  description = "Go linters aggregator",
  install_cmd = "go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
  update_cmd = "go install -v github.com/golangci/golangci-lint/cmd/golangci-lint@latest",
  is_installed = function()
    return helpers.command_exists("golangci-lint")
  end,
}
