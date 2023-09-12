{ config, pkgs, lib, ... }:
{
  home.stateVersion = "22.05";

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # UI apps
    docker
    gimp
    zoom-us
    discord

    # Window management
    rectangle
    raycast

    # Terminal tools
    coreutils
    openssl
    pandoc
    jq
    ripgrep # Required for NeoVim plugins

    # Laguages
    llvmPackages_16.clang-unwrapped
    python312
    go
    nodejs_20
    cargo
    rustc
    gotools
    gopls

    # LSPs
    rust-analyzer
    rustfmt
    nodePackages.typescript-language-server
    nodePackages.eslint

    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macOS CLI commands
  ];

  # Git
  programs.git = {
    enable = true;
    userEmail = "dev@dan.uy";
    userName = "Daniel Bonofiglio";
  };

  # LazyGit
  programs.lazygit.enable = true;

  # Kitty
  programs.kitty = {
      enable = true;
      extraConfig = ''
        map cmd+t no_op
        map cmd+t launch --cwd=current --type=tab
      '';
      font = {
        name = "JetBrainsMonoNL Nerd Font Mono";
        size = 20;
      };
  };

  # NeoVim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = ''
      vim.opt.nu = true
      vim.opt.relativenumber = true
      
      vim.opt.tabstop = 4
      vim.opt.softtabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      
      vim.opt.smartindent = true
      
      vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
      vim.opt.undofile = true
      
      vim.opt.hlsearch = false
      vim.opt.incsearch = true
      
      vim.opt.scrolloff = 8
      vim.opt.signcolumn = "yes"
      vim.opt.isfname:append("@-@")
      
      vim.opt.updatetime = 50
      
      vim.opt.colorcolumn = "80"
      
      vim.g.mapleader = " "

      vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
      
      vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
      vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
      
      vim.keymap.set("n", "J", "mzJ`z")
      
      vim.keymap.set("n", "n", "nzzzv")
      vim.keymap.set("n", "N", "Nzzzv")
      vim.keymap.set("n", "<C-d>", "<C-d>zz")
      vim.keymap.set("n", "<C-u>", "<C-u>zz")
      
      vim.keymap.set("x", "<leader>p", "\"_dP")
      
      vim.keymap.set("x", "<leader>y", "\"+y")
      vim.keymap.set("n", "<leader>y", "\"+y")
      vim.keymap.set("n", "<leader>Y", "\"+Y")
      
      vim.keymap.set("n", "<leader>d", "\"_d")
      vim.keymap.set("v", "<leader>d", "\"_d")
      
      vim.keymap.set("i", "<C-c>", "<Esc>")
      
      vim.keymap.set("n", "Q", "<nop>")
      
      vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
      vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
      
      vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
      
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
      vim.keymap.set("n", "<leader>n", vim.diagnostic.goto_next)
      vim.keymap.set("n", "<leader>N", vim.diagnostic.goto_prev)
      
      vim.keymap.set("n", "<leader>f", "<cmd> bp <CR>")
      vim.keymap.set("n", "<leader>j", "<cmd> bn <CR>")
      vim.keymap.set("n", "<leader>x", "<cmd> bd <CR>")
      
      vim.keymap.set("n", "<leader>w", function()
          vim.lsp.buf.format()
          vim.cmd("write");
      end)
    '';
    plugins = with pkgs.vimPlugins; [
      {
          plugin = undotree;
          type = "lua";
          config = "vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)";
      }
      {
          plugin = leap-nvim;
          type = "lua";
          config = "require('leap').add_default_mappings()";
      }
      {
          plugin = vim-fugitive;
          type = "lua";
          config = "vim.keymap.set('n', '<leader>gs', vim.cmd.Git)";
      }
      {
        plugin = nvim-scrollbar;
        type = "lua";
        config = "require('scrollbar').setup()";
      }
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''
          local builtin = require('telescope.builtin')
          local actions = require "telescope.actions"
          
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
                          ["<C-k>"] = "move_selection_previous"
                      }
                  }
              }
          }

          require("telescope").load_extension "frecency"
        '';
      }
      {
          plugin = telescope-frecency-nvim;
          type = "lua";
          config = "vim.keymap.set('n', '<leader>pf', '<Cmd>Telescope frecency workspace=CWD<CR>')";
      }
      {
          plugin = catppuccin-nvim;
          type = "lua";
          config = "vim.cmd.colorscheme('catppuccin')";
      }
      nvim-lspconfig
      nvim-cmp
      cmp-nvim-lsp
      luasnip
      {
          plugin = lsp-zero-nvim;
          type = "lua";
          config = ''
            local lsp = require('lsp-zero').preset({})
            
            lsp.preset("recommended")
            
            local lsp_list = {
                -- LSP:
                'rome', -- TS, JS, CSS, HTML Toolkit
                -- TS/JS
                'tsserver',
                -- 'denols',
                -- NPM
                'eslint',
                'prismals',
                'svelte',
                'volar', -- Vue LSP
                -- HTML, CSS
                'html',
                'cssls',
                'cssmodules_ls',
                'tailwindcss',
                -- Configuration files
                'jsonls',
                'yamlls',
                --	'docker_compose_language_server',
                'dockerls',
                'taplo', -- TOML Toolkit
                -- 'nginx-language-server',
            
                'lua_ls',
                'rust_analyzer',
                'gopls', -- Go LSP
                'pylsp',
                'clangd',
                'graphql',
                'hls', -- Haskell LSP
                'bashls',
                -- 'ocamllsp',
                'terraformls',
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
            
            lsp.ensure_installed(lsp_list)
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
            
            require('lspconfig').clangd.setup{
                capabilities = clangd_capabilities
            }
            
            lsp.setup()
          '';
      }
      {
          plugin = bufferline-nvim;
          type = "lua";
          config = ''
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
          '';
      }
      {
          plugin = lualine-nvim;
          type = "lua";
          config = ''
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'catppuccin',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    disabled_filetypes = {
                        statusline = {},
                        winbar = {},
                    },
                    ignore_focus = {},
                    always_divide_middle = true,
                    globalstatus = false,
                    refresh = {
                        statusline = 1000,
                        tabline = 1000,
                        winbar = 1000,
                    }
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', },
                    lualine_c = {},
                    lualine_x = { 'diff' },
                    lualine_y = { 'encoding', 'filetype' },
                    lualine_z = { 'location' }
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                },
                tabline = {},
                winbar = {},
                inactive_winbar = {},
                extensions = {}
            }
          '';
      }
      {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = ''
            require'nvim-treesitter.configs'.setup {
              highlight = {
                enable = true,
            
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
              },
            }
          '';
      }
    ];
  };
}
