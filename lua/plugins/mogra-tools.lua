return {
  {
    "bhargavms/mogra-toolchain.nvim",
    -- dir = "~/projects/mogra-toolchain.nvim",
    name = "mogra-toolchain",
    lazy = false,
    opts = {
      ui = {
        title = "Toolchain",
        width = 60,
        height = 20,
        border = "rounded",
      },
      tools = require("mogra.toolchain").get(),
    },
    config = function(_, opts)
      require("mogra_toolchain").setup(opts)
    end,
  },
}
