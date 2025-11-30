local helpers = require("mogra.toolchain.helpers")

return {
  name = "go-enum",
  description = "Generate Go enums from comments",
  install_cmd = "go install -v github.com/abice/go-enum@latest",
  update_cmd = "go install -v github.com/abice/go-enum@latest",
  is_installed = function()
    return helpers.command_exists("go-enum")
  end,
}
