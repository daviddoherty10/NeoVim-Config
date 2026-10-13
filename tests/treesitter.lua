-- Exercise migration recovery and real Go highlight predicates, including edits.
local ok, err = xpcall(function()
    local original = require("nvim-treesitter")
    assert(type(original.install) == "function", "Restore nvim-treesitter's main branch first")
    local notify = vim.notify
    local warning
    vim.notify = function(message, level)
        if level == vim.log.levels.WARN then
            warning = message
        end
    end
    package.loaded["nvim-treesitter"] = {
        setup = function()
            error("Legacy setup must not run")
        end,
    }
    local spec = dofile(vim.fn.stdpath("config") .. "/lua/plugins/treesitter.lua")[1]
    local success, failure = pcall(spec.config)
    vim.wait(100, function()
        return warning ~= nil
    end)
    package.loaded["nvim-treesitter"] = original
    vim.notify = notify
    assert(success, failure)
    assert(warning and warning:find(":Lazy restore nvim%-treesitter"), "Missing migration guidance")

    local buf = vim.api.nvim_create_buf(true, false)
    vim.api.nvim_set_current_buf(buf)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "package main",
        'import "fmt"',
        "type User struct { Name string }",
        "func main() {",
        '    u := User{Name: "David"}',
        "    fmt.Println(u.Name)",
        "}",
    })
    vim.bo[buf].filetype = "go"
    vim.treesitter.start(buf, "go")
    local parser = assert(vim.treesitter.get_parser(buf, "go"))
    local query = assert(vim.treesitter.query.get("go", "highlights"))
    local function check()
        local tree = assert(parser:parse()[1])
        local captures = 0
        for _ in query:iter_captures(tree:root(), buf, 0, -1) do
            captures = captures + 1
        end
        assert(captures > 0, "Go highlight query produced no captures")
    end
    check()
    vim.api.nvim_buf_set_lines(buf, 4, 5, false, { '    u := User{Name: "Edited"}' })
    check()
    vim.cmd("redraw!")
    assert(vim.v.errmsg == "", vim.v.errmsg)
    print("PASS: legacy Treesitter recovery warning, Go highlighting predicates and edits")
end, debug.traceback)
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd("cquit 1")
end
vim.cmd("qa!")
