local web = require "mogra.tooling.web"

local function write(path, lines)
  vim.fn.mkdir(vim.fs.dirname(path), "p")
  vim.fn.writefile(lines, path)
end

local root = vim.fn.tempname()
local functions_root = vim.fs.joinpath(root, "functions")

vim.fn.mkdir(vim.fs.joinpath(root, "src", "app"), "p")
vim.fn.mkdir(vim.fs.joinpath(functions_root, "src"), "p")

write(vim.fs.joinpath(root, "angular.json"), { "{}" })
write(vim.fs.joinpath(root, ".oxfmtrc.json"), { "{}" })
write(vim.fs.joinpath(root, ".oxlintrc.json"), { "{}" })
write(vim.fs.joinpath(root, "jest.config.js"), { "module.exports = {}" })
write(vim.fs.joinpath(root, "package.json"), {
  vim.json.encode({
    name = "web-app",
    engines = { node = "22" },
    devDependencies = { jest = "29", oxfmt = "0.53", oxlint = "1.68" },
  }),
})

write(vim.fs.joinpath(functions_root, ".eslintrc.js"), { "module.exports = {}" })
write(vim.fs.joinpath(functions_root, "jest.config.js"), { "module.exports = {}" })
write(vim.fs.joinpath(functions_root, "package.json"), {
  vim.json.encode({
    name = "functions",
    engines = { node = "20" },
    devDependencies = { eslint = "8", jest = "29", prettier = "3" },
  }),
})

local frontend_file = vim.fs.joinpath(root, "src", "app", "card.component.ts")
local template_file = vim.fs.joinpath(root, "src", "app", "card.component.html")
local functions_file = vim.fs.joinpath(functions_root, "src", "handler.test.ts")
write(frontend_file, { "export class CardComponent {}" })
write(template_file, { "<section></section>" })
write(functions_file, { "test('handler', () => {})" })

local frontend = web.workspace(frontend_file)
assert(frontend.root == root, "frontend workspace should use the Angular root")
assert(frontend.linter == "oxlint", "frontend workspace should use oxlint")
assert(frontend.formatter == "oxfmt", "frontend workspace should use oxfmt")
assert(frontend.node_major == "22", "frontend workspace should use Node 22")
assert(frontend.jest_config == vim.fs.joinpath(root, "jest.config.js"), "frontend Jest config should use root")
assert(
  web.jest_command(frontend_file) == "mise exec node@22 -- ./node_modules/.bin/jest",
  "frontend Jest should run through mise with Node 22"
)

local backend = web.workspace(functions_file)
assert(backend.root == functions_root, "functions workspace should use its nested package root")
assert(backend.linter == "eslint", "functions workspace should use eslint")
assert(backend.formatter == "prettier", "functions workspace should use prettier")
assert(backend.node_major == "20", "functions workspace should use Node 20")
assert(
  backend.jest_config == vim.fs.joinpath(functions_root, "jest.config.js"),
  "functions Jest config should use the nested config"
)
assert(
  web.jest_command(functions_file) == "mise exec node@20 -- ./node_modules/.bin/jest",
  "Functions Jest should run through mise with Node 20"
)
assert(
  vim.deep_equal(web.node_command(frontend_file, "typescript-language-server", { "--stdio" }), {
    "mise",
    "exec",
    "node@22",
    "--",
    "typescript-language-server",
    "--stdio",
  }),
  "frontend Node tooling should use Node 22"
)
assert(
  vim.deep_equal(web.node_command(functions_file, "typescript-language-server", { "--stdio" }), {
    "mise",
    "exec",
    "node@20",
    "--",
    "typescript-language-server",
    "--stdio",
  }),
  "Functions Node tooling should use Node 20"
)

assert(web.is_angular_template(template_file), "HTML beneath angular.json should use the Angular filetype")
assert(not web.is_angular_template(vim.fs.joinpath(functions_root, "src", "email.html")), "nested non-Angular HTML should stay HTML")
assert(web.angular_root(frontend_file) == root, "frontend TypeScript should use the Angular root")
assert(web.angular_root(functions_file) == nil, "nested Functions TypeScript should not use the Angular root")

web.setup_filetypes()
assert(vim.filetype.match({ filename = template_file }) == "htmlangular", "Angular templates should detect htmlangular")
assert(
  vim.filetype.match({ filename = vim.fs.joinpath(functions_root, "src", "email.html") }) == "html",
  "Functions HTML should retain the normal HTML filetype"
)

local conform = require "mogra.options.conform"
local frontend_buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_name(frontend_buf, frontend_file)
vim.bo[frontend_buf].filetype = "typescript"
assert(conform.formatters_by_ft.typescript(frontend_buf)[1] == "oxfmt", "frontend TypeScript should format with oxfmt")

local backend_buf = vim.api.nvim_create_buf(false, false)
vim.api.nvim_buf_set_name(backend_buf, functions_file)
vim.bo[backend_buf].filetype = "typescript"
assert(conform.formatters_by_ft.typescript(backend_buf)[1] == "prettier", "functions TypeScript should format with Prettier")
local prettier_context = { filename = functions_file }
assert(conform.formatters.prettier.command(nil, prettier_context) == "mise", "Functions Prettier should launch through mise")
assert(
  conform.formatters.prettier.prepend_args(nil, prettier_context)[2] == "node@20",
  "Functions Prettier should use Node 20"
)

local save_opts = conform.format_on_save(frontend_buf)
assert(save_opts.timeout_ms == 1000, "format-on-save should have a bounded timeout")
assert(save_opts.lsp_format == "fallback", "format-on-save should use LSP only as a fallback")

local finn = require "mogra.projects.finn_web"
local tasks = finn.tasks()
assert(#tasks >= 6, "FINN should expose its safe development tasks")
for _, task in ipairs(tasks) do
  local command = table.concat(task.command, " ")
  assert(not command:match "deploy", "FINN task launcher must not expose deploy commands")
  assert(not command:match "build%-prod", "FINN task launcher must not expose production builds")
end

vim.fn.delete(root, "rf")
print "PASS: web tooling workspace routing"
