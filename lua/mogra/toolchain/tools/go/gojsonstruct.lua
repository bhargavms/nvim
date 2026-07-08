local helpers = require("mogra.toolchain.helpers")

return {
  name = "gojsonstruct",
  description = "Generate Go structs from JSON",
  install_cmd = "go install -v github.com/twpayne/go-jsonstruct/cmd/gojsonstruct@latest",
  update_cmd = "go install -v github.com/twpayne/go-jsonstruct/cmd/gojsonstruct@latest",
  is_installed = function()
    return helpers.command_exists("gojsonstruct")
  end,
}
