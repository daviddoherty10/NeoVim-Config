local opt = vim.opt
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.wrap = false
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.splitright = true
opt.splitbelow = true
opt.updatetime = 250
opt.timeoutlen = 400
opt.guicursor = "i:block-blinkwait0-blinkoff150-blinkon200"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.laststatus = 3
opt.pumheight = 12
opt.winborder = "rounded"
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(opt.undodir:get()[1], "p")
-- Keep yank behaviour explicit: <leader>y uses the system clipboard.
opt.clipboard = ""
-- Preserve your choice not to write ShaDa; persistent undo is independent.
opt.shada = ""
