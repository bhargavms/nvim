return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300, -- delay before showing (ms)
      icons = {
        breadcrumb = "»",
        separator = "➜",
        group = "+",
      },
      win = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register group labels for better organization
      wk.add({
        { "<leader>f", group = "Find (fzf)" },
        { "<leader>l", group = "LSP (telescope)" },
        { "<leader>g", group = "Git" },
        { "<leader>x", group = "Xcode" },
        { "<leader>w", group = "Workspace/Which-key" },
        { "<leader>b", group = "Buffer" },
      })
    end,
  },
}
