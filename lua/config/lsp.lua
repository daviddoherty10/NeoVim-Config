local M = {}
function M.setup()
    vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        virtual_text = { spacing = 2, prefix = "●" },
        float = { border = "rounded", source = true },
        signs = {
            text = {
                [vim.diagnostic.severity.ERROR] = "E",
                [vim.diagnostic.severity.WARN] = "W",
                [vim.diagnostic.severity.INFO] = "I",
                [vim.diagnostic.severity.HINT] = "H",
            },
        },
    })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLsp", { clear = true }),
        callback = function(args)
            local function map(mode, key, action, desc)
                vim.keymap.set(mode, key, action, { buffer = args.buf, desc = desc, silent = true })
            end
            map("n", "K", vim.lsp.buf.hover, "Hover documentation")
            map("n", "gs", vim.lsp.buf.signature_help, "Signature help")
            map("n", "gd", vim.lsp.buf.definition, "Go to definition")
            map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
            map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
            map("n", "go", vim.lsp.buf.type_definition, "Go to type definition")
            map("n", "gr", vim.lsp.buf.references, "Find references")
            map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
            map({ "n", "x" }, "<F4>", vim.lsp.buf.code_action, "Code action")
        end,
    })
    vim.lsp.config("*", { capabilities = require("cmp_nvim_lsp").default_capabilities() })
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
                telemetry = { enable = false },
            },
        },
    })
    vim.lsp.config("gopls", {
        settings = {
            gopls = { gofumpt = true, staticcheck = true, analyses = { unusedparams = true } },
        },
    })
    vim.lsp.config("clangd", {
        cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
    })
    -- Workspace identity is based on the full root path, not just its basename.
    -- Support Ant/NetBeans projects and loose Java lab files as well as Maven/Gradle.
    vim.lsp.config("jdtls", {
        root_dir = function(bufnr, on_dir)
            on_dir(vim.fs.root(bufnr, {
                "mvnw",
                "gradlew",
                "settings.gradle",
                "settings.gradle.kts",
                "pom.xml",
                "build.gradle",
                "build.gradle.kts",
                "build.xml",
                ".git",
            }) or vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr)))
        end,
        cmd = function(dispatchers, config)
            local root = vim.uv.fs_realpath(config.root_dir) or config.root_dir
            local workspace = vim.fn.stdpath("data") .. "/jdtls/" .. vim.fn.sha256(root):sub(1, 16)
            vim.fn.mkdir(workspace, "p")
            return vim.lsp.rpc.start({ "jdtls", "-data", workspace }, dispatchers, {
                cwd = config.root_dir,
                env = vim.env.JDTLS_JAVA_HOME and { JAVA_HOME = vim.env.JDTLS_JAVA_HOME } or nil,
            })
        end,
    })
end
return M
