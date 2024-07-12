return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    opts = function()
      return require "mogra.options.nvimtree"
    end,
    config = require "mogra.options.nvimtree",
  },
}
