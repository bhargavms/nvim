local M = {}

M.name = "Kotlin LSP"
M.description = "Kotlin Language Server (kotlin-lsp)"

local install_dir = os.getenv "HOME" .. "/.local/kotlin-lsp"
local home_dir = os.getenv "HOME"

function M.is_installed()
  return vim.fn.executable "kotlin-ls" == 1
end

function M.install()
  if vim.fn.isdirectory(install_dir) == 1 then
    os.execute("rm -rf " .. install_dir)
  end
  os.execute("git clone https://github.com/Kotlin/kotlin-lsp.git " .. install_dir)
  os.execute("chmod +x " .. install_dir .. "/scripts/kotlin-lsp.sh")
  os.execute("ln -s " .. install_dir .. "/scripts/kotlin-lsp.sh" .. home_dir .. "/.local/bin/kotlin-ls")
  vim.notify("Kotlin LSP installed!", vim.log.levels.SUCCESS)
end

function M.update() end

return M
