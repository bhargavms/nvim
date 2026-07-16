local function init()
  local web = require "mogra.tooling.web"
  local neotest = require "neotest"

  local function workspace(path)
    path = path or vim.api.nvim_buf_get_name(0)
    return web.workspace(path)
  end

  neotest.setup({
    adapters = {
      require("neotest-jest")({
        jestCommand = web.jest_command,
        jestConfigFile = function(path)
          return workspace(path).jest_config
        end,
        cwd = function(path)
          return workspace(path).root
        end,
      }),
    },
    discovery = {
      enabled = true,
    },
    quickfix = {
      open = false,
    },
  })

  vim.api.nvim_create_user_command("TestNearest", function()
    neotest.run.run()
  end, { desc = "Run nearest test" })
  vim.api.nvim_create_user_command("TestFile", function()
    neotest.run.run(vim.fn.expand "%")
  end, { desc = "Run current test file" })
  vim.api.nvim_create_user_command("TestSummary", function()
    neotest.summary.toggle()
  end, { desc = "Toggle test summary" })
  vim.api.nvim_create_user_command("TestOutput", function()
    neotest.output.open({ enter = true })
  end, { desc = "Open test output" })
  vim.api.nvim_create_user_command("TestDebug", function()
    neotest.run.run({ strategy = "dap" })
  end, { desc = "Debug nearest test" })
end

return init
