local helpers = require("mogra.toolchain.helpers")

return {
  name = "Java (SDKMAN)",
  description = "Java JDK via SDKMAN!",
  get_install_cmd = function()
    local java_version = helpers.read_toolchain_version("java")
    local sdkman_dir = vim.fn.expand("~/.sdkman")

    if vim.fn.isdirectory(sdkman_dir) == 0 then
      return string.format([[
        curl -s 'https://get.sdkman.io' | bash && \
        source ~/.sdkman/bin/sdkman-init.sh && \
        sdk install java %s
      ]], java_version)
    else
      return string.format([[
        source ~/.sdkman/bin/sdkman-init.sh && \
        sdk install java %s
      ]], java_version)
    end
  end,
  get_update_cmd = function()
    local java_version = helpers.read_toolchain_version("java")
    return string.format([[
      source ~/.sdkman/bin/sdkman-init.sh && \
      sdk install java %s
    ]], java_version)
  end,
  is_installed = function()
    return helpers.command_exists("java")
  end,
}
