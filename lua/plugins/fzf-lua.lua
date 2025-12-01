return {
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
      { "<leader>ff", desc = "Find files" },
      { "<leader>fw", desc = "Live grep" },
      { "<leader>fb", desc = "Find buffers" },
    },
    opts = require "mogra.options.fzf-lua",
    config = require "mogra.configs.fzf-lua",
  },
}
