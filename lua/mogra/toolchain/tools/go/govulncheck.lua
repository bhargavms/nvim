local helpers = require("mogra.toolchain.helpers")

return {
  name = "govulncheck",
  description = "Go vulnerability checker",
  install_cmd = "go install -v golang.org/x/vuln/cmd/govulncheck@latest",
  update_cmd = "go install -v golang.org/x/vuln/cmd/govulncheck@latest",
  is_installed = function()
    return helpers.command_exists("govulncheck")
  end,
}
