local lsp = require('lsp-zero').preset({})

lsp.preset("recommended")

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local lsp_list = {
    -- TS/JS
    'tsserver',
    -- 'denols',
    -- NPM
    'eslint',
    'svelte',
    'volar', -- Vue LSP
    -- HTML, CSS
    'html',
    'cssls',
    'emmet_ls',
    -- 'cssmodules_ls',
    -- 'tailwindcss',
    -- Configuration files
    'jsonls',
    'yamlls',
    'docker_compose_language_service',
    'dockerls',
    'taplo', -- TOML Toolkit
    -- 'nginx-language-server',

    'nil_ls', -- Nix LSP
    'lua_ls',
    'rust_analyzer',
    'gopls', -- Go LSP
    -- 'pylsp',
    'clangd',
    -- 'graphql',
    -- 'hls', -- Haskell LSP
    'bashls',
    -- 'ocamllsp',
    -- 'terraformls',
    -- 'zls', -- Zig LSP
    -- Linters:
    -- 'cpplint',
    -- 'staticcheck', -- Go linter
    -- Formatters:
    -- 'clang-format',
    -- 'prettier',
    -- 'gofumpt',
    -- 'ocamlformat',
    -- 'rustfmt',
}

lsp.setup_servers(lsp_list)

local cmp = require('cmp')
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-l>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
    mapping = cmp_mappings,
})

lsp.on_attach(function(client, bufnr)
    local opts = { buffer = bufnr, remap = false }
    lsp.default_keymaps(opts)

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    vim.keymap.set("n", "<leader>va", function() vim.lsp.buf.format() end, opts)
end)

local clangd_capabilities = require('cmp_nvim_lsp').default_capabilities()
clangd_capabilities.textDocument.semanticHighlighting = true
clangd_capabilities.offsetEncoding = "utf-8"

require('lspconfig').clangd.setup {
    capabilities = clangd_capabilities
}

require('lspconfig').lua_ls.setup {
    settings = {
        Lua = {
            completion = { callSnippet = "Replace" },
        }
    }
}

lsp.setup()
