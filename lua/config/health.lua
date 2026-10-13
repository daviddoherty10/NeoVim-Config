local M = {}
function M.check()
    vim.health.start("Neovim config prerequisites")
    for _, tool in ipairs({ "git", "rg", "node", "npm", "python3", "go", "cc", "tree-sitter" }) do
        if vim.fn.executable(tool) == 1 then
            vim.health.ok(tool .. " found")
        else
            vim.health.error(tool .. " missing; see README.md installation requirements")
        end
    end
    local java = vim.env.JDTLS_JAVA_HOME and (vim.env.JDTLS_JAVA_HOME .. "/bin/java") or "java"
    local found, process = pcall(vim.system, { java, "-version" }, { text = true })
    if not found then
        vim.health.error("Java executable missing; set JDTLS_JAVA_HOME (see README.md)")
        return
    end
    local result = process:wait()
    local output = (result.stderr or "") .. (result.stdout or "")
    local major = tonumber(output:match('version "(%d+)') or output:match("openjdk (%d+)"))
    if result.code == 0 and major and major >= 21 then
        vim.health.ok("JDT LS Java runtime: " .. major)
    else
        vim.health.error("JDT LS requires Java 21+; set JDTLS_JAVA_HOME (see README.md)")
    end
end
return M
