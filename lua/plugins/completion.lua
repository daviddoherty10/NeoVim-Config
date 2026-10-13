return {
    {
        "hrsh7th/nvim-cmp",
        event = "InsertEnter",
        dependencies = { "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path" },
        config = function()
            local cmp = require("cmp")
            local select = { behavior = cmp.SelectBehavior.Select }
            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.snippet.expand(args.body)
                    end,
                },
                preselect = cmp.PreselectMode.None,
                mapping = {
                    ["<C-p>"] = cmp.mapping.select_prev_item(select),
                    ["<C-n>"] = cmp.mapping.select_next_item(select),
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<Up>"] = cmp.mapping.select_prev_item(select),
                    ["<Down>"] = cmp.mapping.select_next_item(select),
                    -- Tab and Shift-Tab deliberately keep their normal behaviour.
                },
                sources = cmp.config.sources({ { name = "nvim_lsp" }, { name = "path" } }, {
                    { name = "buffer", keyword_length = 3 },
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
            })
        end,
    },
    { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
    {
        "windwp/nvim-ts-autotag",
        ft = { "html", "javascriptreact", "typescriptreact", "svelte", "vue", "xml" },
        opts = {},
    },
}
