return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            {
                "mason-org/mason.nvim",
                cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
                opts = { ui = { border = "rounded" } },
            },
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local tools = require("config.tools")
            local install = vim.g.auto_install_tools ~= false
            require("config.lsp").setup()
            require("mason-lspconfig").setup({
                ensure_installed = install and tools.servers or {},
                automatic_enable = tools.servers,
            })
            -- Support external binaries without trying to spawn missing servers
            -- during first-run installation. Mason enables each server when ready.
            local dynamic_binaries = {
                jdtls = "jdtls",
                eslint = "vscode-eslint-language-server",
                tailwindcss = "tailwindcss-language-server",
            }
            for _, name in ipairs(tools.servers) do
                local cmd = vim.lsp.config[name].cmd
                local binary = type(cmd) == "table" and cmd[1] or dynamic_binaries[name]
                if binary and vim.fn.executable(binary) == 1 then
                    vim.lsp.enable(name)
                end
            end
            require("mason-tool-installer").setup({
                ensure_installed = tools.formatters,
                run_on_start = install,
                start_delay = 1000,
            })
        end,
    },
}
