local M = {}

local helpers = require("mogra.toolchain.helpers")

M.name = "LuaRocks"
M.description = "Lua package manager"

function M.is_installed()
  if not helpers.command_exists("luarocks") then
    return false
  end
  local function has_rock(rock)
    local output = helpers.run_command("luarocks list --local " .. rock .. " 2>&1")
    return output and output:match(rock)
  end
  return has_rock("luacheck") and has_rock("busted")
end

function M.install()
  if M.is_installed() then
    vim.notify("LuaRocks is already installed", vim.log.levels.INFO)
    return
  end

  vim.notify("Installing LuaRocks...", vim.log.levels.INFO)
  local luarocks_version = "3.11.1"
  local lua_version = "5.4.6"
  local temp_dir = os.getenv("HOME") .. "/.local/tmp/luarocks-install"
  local install_dir = os.getenv("HOME") .. "/.local"

  -- Check if Lua is installed
  if not helpers.command_exists("lua") then
    vim.notify("Installing Lua " .. lua_version .. "...", vim.log.levels.INFO)
    os.execute("mkdir -p " .. temp_dir .. "/lua")
    os.execute("cd " .. temp_dir .. "/lua && curl -L -O https://www.lua.org/ftp/lua-" .. lua_version .. ".tar.gz")
    os.execute("cd " .. temp_dir .. "/lua && tar zxf lua-" .. lua_version .. ".tar.gz")
    os.execute("cd " .. temp_dir .. "/lua/lua-" .. lua_version .. " && make macosx && make install INSTALL_TOP=" .. install_dir)
  end

  -- Install LuaRocks
  os.execute("mkdir -p " .. temp_dir)
  os.execute("cd " .. temp_dir .. " && curl -L -O https://luarocks.org/releases/luarocks-" .. luarocks_version .. ".tar.gz")
  os.execute("cd " .. temp_dir .. " && tar zxf luarocks-" .. luarocks_version .. ".tar.gz")
  os.execute("cd " .. temp_dir .. "/luarocks-" .. luarocks_version .. " && ./configure --prefix=" .. install_dir .. " && make && make install")

  -- Setup environment variables
  local shell_rc = os.getenv("HOME") .. "/.zshrc"
  local env_vars = {
    "export PATH=$PATH:" .. install_dir .. "/bin",
    "export LUA_PATH='" .. install_dir .. "/share/lua/" .. lua_version .. "/?.lua;" .. install_dir .. "/share/lua/" .. lua_version .. "/?/init.lua;'",
    "export LUA_CPATH='" .. install_dir .. "/lib/lua/" .. lua_version .. "/?.so;'"
  }

  for _, var in ipairs(env_vars) do
    os.execute("echo '" .. var .. "' >> " .. shell_rc)
  end

  -- Clean up
  os.execute("rm -rf " .. temp_dir)
  vim.notify("LuaRocks installation complete! Please run 'source " .. shell_rc .. "' to update your environment")

  -- After installing LuaRocks, install luacheck and busted
  os.execute("luarocks install --local luacheck")
  os.execute("luarocks install --local busted")
  vim.notify("LuaRocks, luacheck, and busted installation complete!", vim.log.levels.SUCCESS)
end

function M.update()
  if not M.is_installed() then
    vim.notify("LuaRocks is not installed. Please install it first.", vim.log.levels.WARN)
    return
  end

  vim.notify("Updating LuaRocks packages...", vim.log.levels.INFO)
  os.execute("luarocks install --local --server=https://luarocks.org/dev lua-language-server")

  -- After updating LuaRocks, update luacheck and busted
  os.execute("luarocks install --local --force luacheck")
  os.execute("luarocks install --local --force busted")
  vim.notify("LuaRocks, luacheck, and busted update complete!", vim.log.levels.SUCCESS)
end

return M
