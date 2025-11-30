local helpers = require("mogra.toolchain.helpers")

return {
  name = "Android SDK",
  description = "Android SDK command-line tools (macOS)",
  get_install_cmd = function()
    local sdk_version = helpers.read_toolchain_version("android_sdk_cmdline_tools")
    local sdk_dir = vim.fn.expand("~/Library/Android/sdk")
    local temp_dir = vim.fn.expand("~/.local/tmp/android-sdk-install")
    local url = "https://dl.google.com/android/repository/commandlinetools-mac-" .. sdk_version .. "_latest.zip"

    return string.format([[
      mkdir -p %s %s && \
      cd %s && curl -LO %s && \
      unzip -o commandlinetools-mac-%s_latest.zip -d %s/cmdline-tools && \
      mkdir -p %s/cmdline-tools/latest && \
      mv %s/cmdline-tools/cmdline-tools/* %s/cmdline-tools/latest/ && \
      rm -rf %s
    ]],
      temp_dir, sdk_dir,
      temp_dir, url,
      sdk_version, sdk_dir,
      sdk_dir,
      sdk_dir, sdk_dir,
      temp_dir
    )
  end,
  update_cmd = "sdkmanager --update",
  is_installed = function()
    local sdk_dir = vim.fn.expand("~/Library/Android/sdk")
    return helpers.command_exists("sdkmanager") and vim.fn.isdirectory(sdk_dir) == 1
  end,
}
