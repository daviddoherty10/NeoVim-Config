local function telescope(name)
    return function()
        require("telescope.builtin")[name]()
    end
end
return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
        keys = {
            { "<leader>ff", telescope("find_files"), desc = "Find files" },
            {
                "<C-p>",
                function()
                    local ok = pcall(require("telescope.builtin").git_files)
                    if not ok then
                        require("telescope.builtin").find_files()
                    end
                end,
                desc = "Git files (files outside Git)",
            },
            {
                "<leader>ps",
                function()
                    vim.ui.input({ prompt = "Grep > " }, function(input)
                        if input and input ~= "" then
                            require("telescope.builtin").grep_string({ search = input })
                        end
                    end)
                end,
                desc = "Search literal text in project",
            },
            { "<leader>vh", telescope("help_tags"), desc = "Search help" },
            { "<leader>fg", telescope("live_grep"), desc = "Live project search" },
            { "<leader>fb", telescope("buffers"), desc = "Find buffers" },
        },
        opts = {
            defaults = {
                sorting_strategy = "ascending",
                layout_config = { prompt_position = "top" },
                file_ignore_patterns = {
                    "%.o$",
                    "%.out$",
                    "%.exe$",
                    "%.class$",
                    "%.dll$",
                    "%.so$",
                    "%.bin$",
                    "%.obj$",
                    "node_modules/",
                    "%.git/",
                },
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--glob",
                    "!.git/*",
                },
            },
        },
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
        keys = {
            {
                "<leader>a",
                function()
                    require("harpoon"):list():add()
                end,
                desc = "Harpoon: add file",
            },
            {
                "<C-e>",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "Harpoon: menu",
            },
            {
                "<C-h>",
                function()
                    require("harpoon"):list():select(1)
                end,
                desc = "Harpoon: file 1",
            },
            {
                "<C-t>",
                function()
                    require("harpoon"):list():select(2)
                end,
                desc = "Harpoon: file 2",
            },
            {
                "<C-n>",
                function()
                    require("harpoon"):list():select(3)
                end,
                desc = "Harpoon: file 3",
            },
            {
                "<C-s>",
                function()
                    require("harpoon"):list():select(4)
                end,
                desc = "Harpoon: file 4",
            },
        },
    },
    {
        "christoomey/vim-tmux-navigator",
        init = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
        },
        -- Preserve C-h for Harpoon and C-j/k for quickfix. C-l/C-\ remain available.
        keys = {
            { "<C-l>", "<cmd>TmuxNavigateRight<CR>", desc = "Right Vim/tmux pane" },
            { "<C-\\>", "<cmd>TmuxNavigatePrevious<CR>", desc = "Previous Vim/tmux pane" },
            { "<leader>wh", "<cmd>TmuxNavigateLeft<CR>", desc = "Left Vim/tmux pane" },
            { "<leader>wj", "<cmd>TmuxNavigateDown<CR>", desc = "Lower Vim/tmux pane" },
            { "<leader>wk", "<cmd>TmuxNavigateUp<CR>", desc = "Upper Vim/tmux pane" },
            { "<leader>wl", "<cmd>TmuxNavigateRight<CR>", desc = "Right Vim/tmux pane" },
        },
    },
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo history" } },
    },
}
