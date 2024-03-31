local npairs = require('nvim-autopairs')
npairs.setup{}

-- Add rules for autopairs
local Rule = require('nvim-autopairs.rule')
local cond = require('nvim-autopairs.conds')

npairs.add_rules({
    Rule('"', '"'):with_pair(cond.not_after_regex_check('["]')),
    Rule("'", "'"):with_pair(cond.not_after_regex_check("[']")),
    Rule('(', ')'):with_pair(cond.not_after_regex_check("[)]")),
})

npairs.add_rules({
    Rule('"', '"'):with_pair(cond.not_after_regex_check('["]'))
                :with_move(cond.none()),
    Rule("'", "'"):with_pair(cond.not_after_regex_check("[']"))
                :with_move(cond.none()),
    Rule('(', ')'):with_pair(cond.not_after_regex_check("[)]"))
                :with_move(cond.none()),
})

