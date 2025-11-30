local helpers = require("mogra.toolchain.helpers")

return {
  name = "json-to-struct",
  description = "Convert JSON to Go struct",
  install_cmd = "go install -v github.com/tmc/json-to-struct@latest",
  update_cmd = "go install -v github.com/tmc/json-to-struct@latest",
  is_installed = function()
    return helpers.command_exists("json-to-struct")
  end,
}
