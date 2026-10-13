local function format()
    require("conform").format({ async = true, lsp_format = "fallback" })
end
return {
    {
        "stevearc/conform.nvim",
        event = "BufWritePre",
        cmd = { "ConformInfo", "FormatToggle" },
        keys = {
            { "<F3>", format, mode = { "n", "x" }, desc = "Format file or selection" },
            { "<leader>lf", format, mode = { "n", "x" }, desc = "Format file or selection" },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                go = { "goimports", "gofmt" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                -- Svelte requires the project's prettier-plugin-svelte dependency.
                svelte = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                jsonc = { "prettier" },
                yaml = { "prettier" },
                ["yaml.docker-compose"] = { "prettier" },
                markdown = { "prettier" },
                sh = { "shfmt" },
            },
            -- A single formatting pipeline; clangd/jdtls supply the LSP fallback.
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                    return
                end
                return { timeout_ms = 2000, lsp_format = "fallback" }
            end,
        },
        config = function(_, opts)
            require("conform").setup(opts)
            vim.api.nvim_create_user_command("FormatToggle", function()
                vim.g.disable_autoformat = not vim.g.disable_autoformat
                vim.notify("Format on save: " .. (vim.g.disable_autoformat and "off" or "on"))
            end, { desc = "Toggle automatic formatting" })
        end,
    },
}
