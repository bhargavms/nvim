local helpers = require("mogra.toolchain.helpers")

return {
  name = "yamlfix",
  description = "YAML file formatter",
  install_cmd = "pip3 install yamlfix",
  update_cmd = "pip3 install --upgrade yamlfix",
  is_installed = function()
    return helpers.command_exists("yamlfix")
  end,
}
