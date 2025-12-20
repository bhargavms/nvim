return {
  {
    "bhargavms/mogra-toolchain.nvim",
    name = "mogra-toolchain",
    dependencies = { "MunifTanjim/nui.nvim" },
    lazy = false,
    opts = {
      tools = require("mogra.toolchain").get(),
    },
  },
}
