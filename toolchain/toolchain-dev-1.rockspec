package = "toolchain-dev"
version = "1.0-1"
source = {
   url = "git+https://github.com/yourusername/toolchain.git",
   tag = "v1.0"
}
description = {
   summary = "Development files for toolchain plugin",
   detailed = [[
      This package contains development files for the toolchain plugin,
      including test files and dependencies.
   ]],
   homepage = "https://github.com/yourusername/toolchain",
   license = "MIT"
}
dependencies = {
   "lua >= 5.1",
   "busted >= 2.0.0",
   "luassert >= 1.7.0",
   "say >= 1.3.0",
   "luasocket >= 3.0.0"
}
build = {
   type = "builtin",
   modules = {
      ["toolchain.tests.init_spec"] = "tests/init_spec.lua",
   }
}
