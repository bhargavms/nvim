local helpers = require("mogra.toolchain.helpers")

return {
  name = "prettier",
  description = "Code formatter for JS/TS/CSS/HTML/JSON/Markdown",
  install_cmd = "npm install -g prettier",
  update_cmd = "npm install -g prettier@latest",
  is_installed = function()
    return helpers.command_exists("prettier")
  end,
}
