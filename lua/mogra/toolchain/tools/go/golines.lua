local helpers = require("mogra.toolchain.helpers")

return {
  name = "golines",
  description = "Go code formatter that shortens long lines",
  install_cmd = "go install -v github.com/segmentio/golines@latest",
  update_cmd = "go install -v github.com/segmentio/golines@latest",
  is_installed = function()
    return helpers.command_exists("golines")
  end,
}
