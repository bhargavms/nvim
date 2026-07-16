local M = {}

M.root = vim.fs.normalize(vim.fn.expand "~/ewa-services/FINN-Web-App")

local function root_task(name, ...)
  return {
    name = name,
    cwd = M.root,
    command = { "mise", "exec", "--", "npm", ... },
  }
end

local function functions_task(name, ...)
  return {
    name = name,
    cwd = vim.fs.joinpath(M.root, "functions"),
    command = { "mise", "exec", "node@20", "--", "npm", ... },
  }
end

function M.tasks()
  return {
    root_task("Start web", "run", "start"),
    root_task("Lint web", "run", "lint"),
    root_task("Test frontend with coverage", "run", "test:coverage"),
    root_task("Build web for staging", "run", "build-staging"),
    root_task("Run Playwright web tests", "run", "test:integration:web"),
    functions_task("Test Functions", "test", "--", "--runInBand"),
    functions_task("Build Functions", "run", "build"),
  }
end

function M.run()
  if vim.fn.isdirectory(M.root) ~= 1 then
    vim.notify("FINN-Web-App not found at " .. M.root, vim.log.levels.ERROR)
    return
  end

  local tasks = M.tasks()
  vim.ui.select(tasks, {
    prompt = "FINN task",
    format_item = function(task)
      return task.name
    end,
  }, function(task)
    if not task then
      return
    end

    require("snacks").terminal.open(task.command, {
      cwd = task.cwd,
      win = {
        position = "bottom",
        height = 0.35,
        title = " " .. task.name .. " ",
        title_pos = "center",
      },
    })
  end)
end

function M.setup()
  vim.api.nvim_create_user_command("FinnTask", M.run, {})
  vim.keymap.set("n", "<leader>pt", M.run, { desc = "FINN project task" })
end

return M
