local builtin = require('telescope.builtin')
local telescope = require('telescope')

-- Configure Telescope with file_ignore_patterns
telescope.setup {
  file_ignore_patterns = { "%.o", "%.out", "%.exe", "%.class" }
}

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ")})
end)

