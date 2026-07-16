return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-neotest/nvim-nio",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "rcarriga/nvim-dap-ui",
    },
    cmd = { "TestNearest", "TestFile", "TestSummary", "TestOutput", "TestDebug" },
    keys = {
      {
        "<leader>tn",
        "<cmd>TestNearest<cr>",
        desc = "Test nearest",
      },
      {
        "<leader>tf",
        "<cmd>TestFile<cr>",
        desc = "Test file",
      },
      {
        "<leader>tS",
        "<cmd>TestSummary<cr>",
        desc = "Test summary",
      },
      {
        "<leader>to",
        "<cmd>TestOutput<cr>",
        desc = "Test output",
      },
      {
        "<leader>td",
        "<cmd>TestDebug<cr>",
        desc = "Debug nearest test",
      },
      {
        "<leader>tx",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop test",
      },
    },
    config = require "mogra.configs.neotest",
  },
}
