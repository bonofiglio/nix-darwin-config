vim.keymap.set('i', '<C-.>', function() return vim.fn['codeium#Accept']() end, { expr = true })
vim.keymap.set('i', '<c-m>', function() return vim.fn['codeium#CycleCompletions'](1) end, { expr = true })
vim.keymap.set('i', '<c-,>', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true })
vim.keymap.set('i', '<c-n>', function() return vim.fn['codeium#Clear']() end, { expr = true })
