-- Leader must be set before lazy.nvim creates any mappings.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
if vim.fn.has("nvim-0.12") ~= 1 then
    error("This config requires Neovim 0.12+. On macOS: brew upgrade neovim")
end
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
