local helpers = require("mogra.toolchain.helpers")

return {
  name = "iferr",
  description = "Generate if err != nil boilerplate",
  install_cmd = "go install -v github.com/koron/iferr@latest",
  update_cmd = "go install -v github.com/koron/iferr@latest",
  is_installed = function()
    return helpers.command_exists("iferr")
  end,
}
