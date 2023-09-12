vim.opt.termguicolors = true

local bufferline = require("bufferline")

bufferline.setup {
    options = {
        style_preset = {
            bufferline.style_preset.no_italic, bufferline.style_preset.no_bold },
        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon',
        },
        show_buffer_close_icons = false,
        separator_style = "thick",
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count)
            return "(" .. count .. ")"
        end,
    },
}
