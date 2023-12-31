local parser_install_dir = vim.fn.stdpath("cache") .. "/treesitters"
vim.fn.mkdir(parser_install_dir, "p")
-- Prevents reinstall of treesitter plugins every boot
vim.opt.runtimepath:append(parser_install_dir)

function setup_surrealdb()
    vim.filetype.add({
        extension = {
            surql = "surql",
            surrealql = "surql"
        }
    });

    local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
    parser_config.surrealdb = {
        install_info = {
            url = "https://github.com/DariusCorvus/tree-sitter-surrealdb.git",
            files = { "src/parser.c" },
            branch = "main",
        },
        filetype = "surql",
    }

    local highlights_scm = [[
    (keyword) @keyword
    (string) @string
    (number) @number
    (punctuation) @punctuation
    (operator) @operator
    (variable) @type
    (constant) @constant.builtin
    (function) @function
    (bool) @boolean
    (nothing) @type
    (comment) @comment
    (record) @type
    (function) @function
    (property) @field
    (identifier) @constant @text.emphasis (#set! "priority" 120)
    (casting) @conceal
    (duration) @number
    (type) @type
    (delimiter) @punctuation.delimiter
]]

    local injections_scm = [[
    (scripting_content) @javascript
]]

    local runtime_path = vim.fn.stdpath("cache")
    vim.opt.runtimepath:append(runtime_path)
    vim.fn.mkdir(runtime_path .. "/queries/surrealdb", "p")

    if vim.fn.isdirectory(runtime_path .. "/queries/surrealdb") == 1 then
        local highlights_file = io.open(runtime_path .. "/queries/surrealdb/highlights.scm", "w")
        io.output(highlights_file)
        io.write(highlights_scm)
        io.close(highlights_file)

        local injections_file = io.open(runtime_path .. "/queries/surrealdb/injections.scm", "w")
        io.output(injections_file)
        io.write(injections_scm)
        io.close(injections_file)
    end
end

setup_surrealdb()

require 'nvim-treesitter.configs'.setup {
    highlight = {
        enable = true,

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
    },
    parser_install_dir = parser_install_dir,
}
