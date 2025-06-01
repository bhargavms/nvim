-- Add bin directories to PATH
local function add_to_path(path)
  local current_path = vim.env.PATH
  if not current_path:match(path) then
    vim.env.PATH = path .. ":" .. current_path
  end
end

-- Add Mason's bin directory
local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"
add_to_path(mason_bin)

-- Add LuaRocks local bin directory
local luarocks_bin = os.getenv("HOME") .. "/.luarocks/bin"
add_to_path(luarocks_bin)

-- Add local bin directory
local local_bin = os.getenv("HOME") .. "/.local/bin"
add_to_path(local_bin)
