return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "mxsdev/nvim-dap-vscode-js",
    },
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug step out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue" },
      { "<leader>dr", function() require("dap").repl.open() end, desc = "Debug REPL" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Debug UI" },
      { "<leader>dq", function() require("dap").terminate() end, desc = "Debug terminate" },
    },
    config = require "mogra.configs.dap",
  },
}
