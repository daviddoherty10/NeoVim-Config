return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false, -- The current Treesitter plugin does not support lazy-loading.
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.setup({})
            if vim.g.auto_install_tools ~= false then
                ts.install(require("config.tools").parsers)
            end
            local function highlight(bufnr)
                if vim.bo[bufnr].buftype ~= "" or vim.api.nvim_buf_line_count(bufnr) > 20000 then
                    return
                end
                local language = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype)
                if language then
                    pcall(vim.treesitter.start, bufnr, language)
                end
            end
            vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
                group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true }),
                callback = function(args)
                    highlight(args.buf)
                end,
            })
        end,
    },
}
