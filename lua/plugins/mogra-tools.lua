return {
  {
    -- "bhargavms/mogra-toolchain.nvim",
    dir = "~/mogra-toolchain.nvim",
    name = "mogra-toolchain",
    lazy = false,
    opts = {
      ui = {
        title = "Toolchain",
        width = 60,
        height = 20,
        border = "rounded",
      },
      tools = {},
    },
    config = function(_, opts)
      opts.tools = require("mogra.toolchain").get()
      require("mogra_toolchain").setup(opts)
    end,
  },
}
