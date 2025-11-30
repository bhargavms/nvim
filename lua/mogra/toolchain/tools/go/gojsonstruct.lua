local helpers = require("mogra.toolchain.helpers")

return {
  name = "gojsonstruct",
  description = "Generate Go structs from JSON",
  install_cmd = "go install -v github.com/mholt/json-to-go/cmd/json-to-go@latest",
  update_cmd = "go install -v github.com/mholt/json-to-go/cmd/json-to-go@latest",
  is_installed = function()
    return helpers.command_exists("json-to-go")
  end,
}
