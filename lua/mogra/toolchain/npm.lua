local helpers = require("mogra.toolchain.helpers")

return {
  name = "NPM",
  description = "Node.js and npm via nvm",
  get_install_cmd = function()
    return [[
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
      export NVM_DIR="$HOME/.nvm" && \
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
      nvm install --lts && \
      nvm use --lts && \
      npm install -g npm@latest
    ]]
  end,
  update_cmd = "npm install -g npm@latest",
  is_installed = function()
    return helpers.command_exists("npm") or vim.fn.filereadable(os.getenv("HOME") .. "/.nvm/nvm.sh") == 1
  end,
}
