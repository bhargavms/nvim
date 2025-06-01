return {
  dir = vim.fn.stdpath "config" .. "/toolchain",
  name = "toolchain",
  lazy = false, -- Load immediately since it's a core tool
  dev = true,
  opts = {
    ui = {
      title = "Toolchain",
      width = 60,
      height = 20,
      border = "rounded",
    },
    tools = {
      require("mogra.toolchain.init").register_default_tools(require("toolchain.init"))
    }
  },
  config = function(_, opts)
    require("toolchain.init").setup(opts)
  end,
}
