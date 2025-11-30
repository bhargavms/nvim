local helpers = require("mogra.toolchain.helpers")

return {
  name = "LuaRocks",
  description = "Lua package manager with luacheck and busted",
  get_install_cmd = function()
    local luarocks_version = "3.11.1"
    local lua_version = "5.4.6"
    local install_dir = vim.fn.expand("~/.local")
    local temp_dir = vim.fn.expand("~/.local/tmp/luarocks-install")

    return string.format([[
      mkdir -p %s/lua && \
      cd %s/lua && curl -L -O https://www.lua.org/ftp/lua-%s.tar.gz && \
      tar zxf lua-%s.tar.gz && \
      cd lua-%s && make macosx && make install INSTALL_TOP=%s && \
      cd %s && curl -L -O https://luarocks.org/releases/luarocks-%s.tar.gz && \
      tar zxf luarocks-%s.tar.gz && \
      cd luarocks-%s && ./configure --prefix=%s --with-lua=%s --with-lua-include=%s/include --with-lua-lib=%s/lib && \
      make && make install && \
      rm -rf %s && \
      luarocks install luacheck && \
      luarocks install busted
    ]],
      temp_dir,
      temp_dir, lua_version,
      lua_version,
      lua_version, install_dir,
      temp_dir, luarocks_version,
      luarocks_version,
      luarocks_version, install_dir, install_dir, install_dir, install_dir,
      temp_dir
    )
  end,
  update_cmd = "luarocks install --force luacheck && luarocks install --force busted",
  is_installed = function()
    if not helpers.command_exists("luarocks") then
      return false
    end
    local function has_rock(rock)
      local output = helpers.run_command("luarocks list --local " .. rock .. " 2>&1")
      return output and output:match(rock)
    end
    return has_rock("luacheck") and has_rock("busted")
  end,
}
