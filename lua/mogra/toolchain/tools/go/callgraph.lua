local helpers = require("mogra.toolchain.helpers")

return {
  name = "callgraph",
  description = "Go call graph analysis tool",
  install_cmd = "go install -v golang.org/x/tools/cmd/callgraph@latest",
  update_cmd = "go install -v golang.org/x/tools/cmd/callgraph@latest",
  is_installed = function()
    return helpers.command_exists("callgraph")
  end,
}
