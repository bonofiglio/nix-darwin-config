local function setup()
    require("copilot").setup({
        suggestion = {
            enabled = true,
            auto_trigger = true,
            debounce = 100,
            keymap = {
                accept = "<C-.>",
                accept_word = false,
                accept_line = false,
                prev = "<C-,>",
                dismiss = "<C-n>",
            }
        },
    })
end

setup()
