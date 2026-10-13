-- Run after init.lua: nvim --headless --cmd 'let g:auto_install_tools = v:false'
--   '+luafile tests/smoke.lua'
local ok, err = xpcall(function()
    assert(vim.v.errmsg == "", vim.v.errmsg)
    local plugins = {}
    for name in pairs(require("lazy.core.config").plugins) do
        plugins[#plugins + 1] = name
    end
    require("lazy").load({ plugins = plugins })
    vim.wait(100)
    assert(vim.v.errmsg == "", vim.v.errmsg)
    assert(vim.g.mapleader == " ", "Leader changed")
    assert(vim.g.colors_name == "tokyonight-night", "Theme did not load")
    for _, file in ipairs(vim.fn.globpath(vim.fn.stdpath("config"), "lua/**/*.lua", false, true)) do
        assert(loadfile(file), "Invalid Lua: " .. file)
    end

    -- Verify mappings after every plugin has loaded, when collisions become visible.
    local mappings = {
        n = {
            "<leader>pv",
            "J",
            "<C-d>",
            "<C-u>",
            "n",
            "N",
            "<leader>y",
            "<leader>Y",
            "<leader>r",
            "<leader>sv",
            "<leader>sh",
            "<leader>se",
            "<leader>sx",
            "<leader>h",
            "<leader>j",
            "<leader>k",
            "<leader>l",
            "<leader>to",
            "<leader>tx",
            "<leader>tn",
            "<leader>tp",
            "<leader>ff",
            "<C-p>",
            "<leader>ps",
            "<leader>vh",
            "<leader>a",
            "<C-e>",
            "<C-h>",
            "<C-t>",
            "<C-n>",
            "<C-s>",
            "<leader>u",
            "<C-k>",
            "<C-j>",
            "\\k",
            "\\j",
            "\\q",
            "<leader>q",
            "<C-l>",
            "<C-\\>",
            "gl",
            "[d",
            "]d",
            "<F3>",
        },
        i = { "jk", "kj" },
        v = { "J", "K", "<leader>y" },
        x = { "<leader>p", "<F3>" },
    }
    local count = 0
    for mode, keys in pairs(mappings) do
        for _, key in ipairs(keys) do
            assert(
                next(vim.fn.maparg(key, mode, false, true)),
                "Missing mapping: " .. mode .. " " .. key
            )
            count = count + 1
        end
    end
    assert(
        vim.fn.maparg("<C-h>", "n", false, true).desc == "Harpoon: file 1",
        "tmux stole Harpoon key"
    )
    assert(vim.fn.maparg("<C-k>", "n") == "<Cmd>cnext<CR>zz", "tmux stole quickfix key")
    assert(vim.fn.maparg("<leader>j", "n") == "<C-W>j", "Diagnostics stole window key")
    assert(vim.fn.maparg("<leader>k", "n") == "<C-W>k", "Diagnostics stole window key")

    local cmp = require("cmp")
    local mapping = cmp.get_config().mapping
    for _, key in ipairs({ "<C-P>", "<C-N>", "<C-Y>", "<C-Space>", "<C-E>", "<Up>", "<Down>" }) do
        assert(mapping[key], "Missing completion mapping: " .. key)
    end
    assert(not mapping["<Tab>"] and not mapping["<S-Tab>"], "Tab was assigned to completion")
    assert(cmp.get_config().sources[1].name == "nvim_lsp", "LSP completion source missing")

    local tmp = vim.fn.tempname()
    vim.fn.writefile({ "first", "second", "third" }, tmp)
    vim.cmd.edit(tmp)
    vim.fn.setqflist({ { filename = tmp, lnum = 1 }, { filename = tmp, lnum = 3 } })
    vim.cmd.cfirst()
    local function press(key)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, false, true), "mx", false)
    end
    press("<C-k>")
    assert(vim.fn.getqflist({ idx = 0 }).idx == 2, "Quickfix next does not work")
    press("<C-j>")
    assert(vim.fn.getqflist({ idx = 0 }).idx == 1, "Quickfix previous does not work")
    -- Harpoon v2 should retain the add/jump behaviour, not just register a shortcut.
    press("<leader>a")
    vim.cmd.enew()
    press("<C-h>")
    assert(vim.api.nvim_buf_get_name(0) == tmp, "Harpoon failed to jump to file 1")
    require("harpoon"):list():remove_at(1)

    local save_hooks = vim.api.nvim_get_autocmds({ event = "BufWritePre" })
    local formatting_hooks = 0
    for _, hook in ipairs(save_hooks) do
        if hook.group_name == "Conform" then
            formatting_hooks = formatting_hooks + 1
        end
        assert(not (hook.group_name or ""):match("[Ll]sp.?[Zz]ero"), "Old formatter hook survived")
    end
    assert(formatting_hooks == 1, "Expected exactly one Conform save hook")
    vim.fn.delete(tmp)
    print(
        ("PASS: %d preserved mappings, completion, Harpoon, quickfix, all plugins, one save formatter"):format(
            count
        )
    )
end, debug.traceback)
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
end
vim.cmd("qa!")
