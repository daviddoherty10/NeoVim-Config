-- Integration checks against real binaries installed by Mason (or on PATH).
local tmp = vim.fn.tempname()
local ok, err = xpcall(function()
    require("lazy").load({ plugins = { "nvim-lspconfig", "nvim-cmp", "conform.nvim" } })
    local fixtures = {
        {
            server = "emmet_language_server",
            file = "index.html",
            text = { "<html><body></body></html>" },
            diagnostics = false,
        },
        {
            server = "lua_ls",
            file = "main.lua",
            text = { "local x = 1", "print(missing_variable)" },
        },
        {
            server = "ts_ls",
            file = "main.tsx",
            text = { "const x: number = 'wrong';", "export { x };" },
            extra = {
                ["package.json"] = { '{"name":"test","private":true}' },
                ["tsconfig.json"] = { '{"compilerOptions":{"strict":true,"jsx":"react-jsx"}}' },
            },
        },
        {
            server = "gopls",
            file = "main.go",
            text = { "package main", "func main() { missing() }" },
            extra = { ["go.mod"] = { "module example.com/nvim-test", "go 1.24" } },
        },
        {
            server = "jdtls",
            file = "Main.java",
            text = {
                "public class Main {",
                "public static void main(String[] args) { missing(); }",
                "}",
            },
        },
        {
            server = "clangd",
            file = "main.c",
            text = { "int main(void) { return missing; }" },
            extra = { ["compile_flags.txt"] = { "-Wall" } },
        },
        {
            server = "jedi_language_server",
            file = "main.py",
            text = { "def broken(:", "    return 1" },
        },
        { server = "jsonls", file = "main.json", text = { '{ "broken": }' } },
        { server = "yamlls", file = "main.yaml", text = { "broken: [" } },
        {
            server = "bashls",
            file = "main.sh",
            text = { "#!/bin/bash", "echo hello" },
            diagnostics = false,
        },
        {
            server = "html",
            file = "index.html",
            text = { "<!doctype html>", "<html><body>hello</body></html>" },
            diagnostics = false,
        },
        {
            server = "cssls",
            file = "main.css",
            text = { "body { color: red; }" },
            diagnostics = false,
        },
        {
            server = "svelte",
            file = "App.svelte",
            text = { "<script>let message = 'hello';</script>", "<p>{message}</p>" },
            extra = {
                ["package.json"] = { '{"name":"svelte-test","private":true}' },
                ["svelte.config.js"] = { "module.exports = {};" },
            },
            diagnostics = false,
        },
        {
            server = "dockerls",
            file = "Dockerfile",
            text = { "FROM alpine:latest", "RUN echo hello" },
            diagnostics = false,
        },
        {
            server = "docker_compose_language_service",
            file = "compose.yaml",
            text = { "services:", "  app:", "    image: alpine:latest" },
            diagnostics = false,
        },
    }
    if vim.env.NVIM_TEST_WEB_DEPS then
        fixtures[#fixtures + 1] = {
            server = "eslint",
            file = "main.js",
            text = { "missingVariable();" },
            extra = {
                ["package.json"] = { '{"name":"eslint-test","private":true}' },
                ["eslint.config.mjs"] = { 'export default [{ rules: { "no-undef": "error" } }];' },
            },
        }
        fixtures[#fixtures + 1] = {
            server = "tailwindcss",
            file = "index.html",
            text = { '<div class="text-red-500">hello</div>' },
            extra = {
                ["package.json"] = {
                    '{"name":"tailwind-test","private":true,"dependencies":{"tailwindcss":"^3.4.0"}}',
                },
                ["tailwind.config.js"] = { 'module.exports = { content: ["./*.html"] };' },
            },
            diagnostics = false,
        }
    else
        print("SKIP: ESLint and Tailwind project fixtures (set NVIM_TEST_WEB_DEPS; see README)")
    end
    vim.fn.mkdir(tmp, "p")
    for _, fixture in ipairs(fixtures) do
        local dir = tmp .. "/" .. fixture.server
        vim.fn.mkdir(dir .. "/.git", "p")
        if vim.env.NVIM_TEST_WEB_DEPS then
            assert(vim.uv.fs_symlink(vim.env.NVIM_TEST_WEB_DEPS, dir .. "/node_modules"))
        end
        for filename, content in pairs(fixture.extra or {}) do
            vim.fn.writefile(content, dir .. "/" .. filename)
        end
        local filename = dir .. "/" .. fixture.file
        vim.fn.writefile(fixture.text, filename)
        vim.cmd.edit(filename)
        local bufnr = vim.api.nvim_get_current_buf()
        local client
        assert(
            vim.wait(45000, function()
                client = vim.lsp.get_clients({ bufnr = bufnr, name = fixture.server })[1]
                return client and client.initialized
            end, 100),
            fixture.server .. " failed to attach: check :Mason and :LspLog"
        )
        for _, key in ipairs({ "gd", "gD", "gi", "go", "gr", "K", "gs", "<F2>", "<F4>" }) do
            assert(vim.fn.maparg(key, "n", false, true).buffer == 1, "LSP mapping missing: " .. key)
        end
        local method = client:supports_method("textDocument/documentSymbol")
                and "textDocument/documentSymbol"
            or client:supports_method("textDocument/completion") and "textDocument/completion"
            or client:supports_method("textDocument/codeAction") and "textDocument/codeAction"
            or "textDocument/hover"
        local response = client:request_sync(method, {
            textDocument = { uri = vim.uri_from_bufnr(bufnr) },
            position = { line = 0, character = 0 },
            range = { start = { line = 0, character = 0 }, ["end"] = { line = 0, character = 1 } },
            context = { diagnostics = {} },
        }, 30000, bufnr)
        assert(response and not response.err, fixture.server .. " did not answer " .. method)
        if fixture.diagnostics ~= false then
            assert(
                vim.wait(30000, function()
                    return #vim.diagnostic.get(bufnr) > 0
                end, 100),
                fixture.server .. " did not report the deliberate error"
            )
        end
        assert(
            client.capabilities.textDocument.completion.completionItem.snippetSupport,
            fixture.server .. " missing completion capabilities"
        )
        print(
            "PASS: "
                .. fixture.server
                .. " attached, replied"
                .. (fixture.diagnostics ~= false and ", returned diagnostics" or "")
        )
        client:stop()
        vim.wait(5000, function()
            return client:is_stopped()
        end, 100)
        vim.cmd("bwipeout!")
    end
end, debug.traceback)
for _, client in ipairs(vim.lsp.get_clients()) do
    client:stop()
end
vim.fn.delete(tmp, "rf")
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
end
vim.cmd("qa!")
