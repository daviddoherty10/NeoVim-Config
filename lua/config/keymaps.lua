local map = vim.keymap.set
local function set(mode, lhs, rhs, desc)
    map(mode, lhs, rhs, { desc = desc, silent = true })
end
set("i", "kj", "<Esc>", "Leave insert mode")
set("i", "jk", "<Esc>", "Leave insert mode")
set("n", "<leader>pv", vim.cmd.Ex, "File explorer (netrw)")
set("n", "J", "mzJ`z", "Join lines without moving cursor")
set("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
set("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")
set("n", "<C-d>", "<C-d>zz", "Half page down, centered")
set("n", "<C-u>", "<C-u>zz", "Half page up, centered")
set("n", "n", "nzzzv", "Next search match, centered")
set("n", "N", "Nzzzv", "Previous search match, centered")
set({ "n", "v" }, "<leader>y", [["+y]], "Yank to system clipboard")
set("n", "<leader>Y", [["+Y]], "Yank line to system clipboard")
set("x", "<leader>p", [["_dP]], "Paste without replacing yank register")
map(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word throughout file" }
)
set("n", "<leader>sv", "<C-w>v", "Split vertically")
set("n", "<leader>sh", "<C-w>s", "Split horizontally")
set("n", "<leader>se", "<C-w>=", "Equalize splits")
set("n", "<leader>sx", "<cmd>close<CR>", "Close split")
for _, key in ipairs({ "h", "j", "k", "l" }) do
    set("n", "<leader>" .. key, "<C-w>" .. key, "Go to " .. key .. " window")
end
set("n", "<leader>to", "<cmd>tabnew<CR>", "New tab")
set("n", "<leader>tx", "<cmd>tabclose<CR>", "Close tab")
set("n", "<leader>tn", "<cmd>tabnext<CR>", "Next tab")
set("n", "<leader>tp", "<cmd>tabprevious<CR>", "Previous tab")
set("n", "<C-k>", "<cmd>cnext<CR>zz", "Next quickfix item")
set("n", "<C-j>", "<cmd>cprev<CR>zz", "Previous quickfix item")
set("n", "<leader>q", vim.diagnostic.setloclist, "Buffer diagnostics in location list")
-- dotfiles created these before setting mapleader; keep the actual legacy keys.
set("n", "\\k", "<cmd>lnext<CR>zz", "Next location-list item (legacy)")
set("n", "\\j", "<cmd>lprev<CR>zz", "Previous location-list item (legacy)")
set("n", "\\q", vim.diagnostic.setloclist, "Buffer diagnostics (legacy)")
set("n", "<leader>dk", "<cmd>lnext<CR>zz", "Next location-list item")
set("n", "<leader>dj", "<cmd>lprev<CR>zz", "Previous location-list item")
set("n", "<leader>dq", vim.diagnostic.setqflist, "Workspace diagnostics in quickfix")
set("n", "gl", vim.diagnostic.open_float, "Diagnostic details")
set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, "Previous diagnostic")
set("n", "]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, "Next diagnostic")
-- The old `unmap q` never disabled built-in recording. Preserve Vim macros.
