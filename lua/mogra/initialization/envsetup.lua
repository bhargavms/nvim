-- Add bin directories to PATH
local function add_to_path(path)
  local current_path = vim.env.PATH
  if vim.fn.isdirectory(path) == 1 and not current_path:find(path, 1, true) then
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

-- Add Go toolchain and GOPATH bin directories
local go_root_bin = os.getenv("HOME") .. "/.local/go/go/bin"
add_to_path(go_root_bin)

local go_path_bin = os.getenv("HOME") .. "/go/bin"
add_to_path(go_path_bin)

-- Add Android SDK command-line tools
local android_home = os.getenv("ANDROID_HOME") or (os.getenv("HOME") .. "/Library/Android/sdk")
vim.env.ANDROID_HOME = android_home
add_to_path(android_home .. "/cmdline-tools/latest/bin")
add_to_path(android_home .. "/platform-tools")

-- Add Python user script directories
local python_bins = vim.fn.glob(os.getenv("HOME") .. "/Library/Python/*/bin", false, true)
for _, python_bin in ipairs(python_bins) do
  add_to_path(python_bin)
end
