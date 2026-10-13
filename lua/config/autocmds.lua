-- Neovim otherwise detects these as plain YAML, which prevents Compose LSP attach.
vim.filetype.add({
    filename = {
        ["compose.yaml"] = "yaml.docker-compose",
        ["compose.yml"] = "yaml.docker-compose",
        ["docker-compose.yaml"] = "yaml.docker-compose",
        ["docker-compose.yml"] = "yaml.docker-compose",
    },
})
vim.treesitter.language.register("yaml", "yaml.docker-compose")

local group = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank({ timeout = 150 })
    end,
})
vim.api.nvim_create_autocmd("CursorHold", {
    group = group,
    callback = function()
        if vim.api.nvim_get_mode().mode == "n" then
            vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
        end
    end,
})
