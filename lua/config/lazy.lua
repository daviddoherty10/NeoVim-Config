local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local output = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
    if vim.v.shell_error ~= 0 then
        error("Could not install lazy.nvim:\n" .. output)
    end
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
    spec = { { "folke/lazy.nvim", branch = "stable" }, { import = "plugins" } },
    defaults = { lazy = true },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = { enabled = false },
    change_detection = { notify = false },
    ui = { border = "rounded" },
    -- Do not load a second copy of plugins from an old Packer installation.
    performance = { rtp = { reset = true }, reset_packpath = true },
})
