local function init()
  local dap = require "dap"
  local dapui = require "dapui"
  local web = require "mogra.tooling.web"
  local finn_root = require("mogra.projects.finn_web").root

  require("dap-vscode-js").setup({
    debugger_cmd = web.node_command(finn_root, "js-debug-adapter"),
    adapters = { "pwa-node", "pwa-chrome" },
  })

  dapui.setup()

  local function open_dapui()
    dapui.open()
  end

  local function close_dapui()
    dapui.close()
  end

  dap.listeners.before.attach.mogra_dapui = open_dapui
  dap.listeners.before.launch.mogra_dapui = open_dapui
  dap.listeners.before.event_terminated.mogra_dapui = close_dapui
  dap.listeners.before.event_exited.mogra_dapui = close_dapui

  local function node_runtime()
    local path = vim.api.nvim_buf_get_name(0)
    local node_major = web.workspace(path).node_major
    if node_major then
      return "mise", { "exec", "node@" .. node_major, "--", "node" }
    end
    return "node", {}
  end

  local configurations = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch current JavaScript/TypeScript file",
      program = "${file}",
      cwd = "${workspaceFolder}",
      runtimeExecutable = function()
        return node_runtime()
      end,
      runtimeArgs = function()
        local _, args = node_runtime()
        return args
      end,
      sourceMaps = true,
      skipFiles = { "<node_internals>/**", "**/node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach to Node process",
      processId = require("dap.utils").pick_process,
      cwd = "${workspaceFolder}",
      sourceMaps = true,
    },
    {
      type = "pwa-chrome",
      request = "launch",
      name = "Launch FINN Angular in Chrome",
      url = "http://localhost:4200",
      webRoot = finn_root,
      sourceMaps = true,
      sourceMapPathOverrides = {
        ["webpack:/*"] = finn_root .. "/*",
        ["/*"] = "*",
      },
    },
  }

  for _, language in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
    dap.configurations[language] = vim.list_extend(dap.configurations[language] or {}, vim.deepcopy(configurations))
  end

  vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
  vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })
end

return init
