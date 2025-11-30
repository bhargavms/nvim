local helpers = require("mogra.toolchain.helpers")

return {
  name = "ginkgo",
  description = "BDD testing framework for Go",
  install_cmd = "go install -v github.com/onsi/ginkgo/v2/ginkgo@latest",
  update_cmd = "go install -v github.com/onsi/ginkgo/v2/ginkgo@latest",
  is_installed = function()
    return helpers.command_exists("ginkgo")
  end,
}
