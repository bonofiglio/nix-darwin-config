local builtin = require('telescope.builtin')
local actions = require "telescope.actions"
local trouble = require("trouble.providers.telescope")

vim.keymap.set('n', '<C-p>', function() builtin.find_files() end, {})
vim.keymap.set('n', '<leader>pg', function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.live_grep()
end)

require "telescope".setup {
    pickers = {
        colorscheme = {
            enable_preview = true
        }
    },
    defaults = {
        mappings = {
            i = {
                ["<C-l>"] = "select_default",
                ["<C-j>"] = "move_selection_next",
                ["<C-k>"] = "move_selection_previous",
                ["<C-t>"] = trouble.open_with_trouble
            }
        }
    }
}

require("telescope").load_extension "frecency"
