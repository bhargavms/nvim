local helpers = require("mogra.toolchain.helpers")

return {
  name = "beautysh",
  description = "Bash/Shell script formatter",
  install_cmd = "pip3 install beautysh",
  update_cmd = "pip3 install --upgrade beautysh",
  is_installed = function()
    return helpers.command_exists("beautysh")
  end,
}
