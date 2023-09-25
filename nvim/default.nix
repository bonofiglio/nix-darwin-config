{ config, lib, pkgs, ... }:
let 
    fromGitHub = ref: rev: repo: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = builtins.fetchGit {
            url = "https://github.com/${repo}.git";
            ref = ref;
            rev = rev;
        };
    };
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = builtins.readFile ./lua/settings.lua;
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
        config = builtins.readFile ./lua/telescope.lua;
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
          config = builtins.readFile ./lua/lsp.lua;
      }
      {
          plugin = bufferline-nvim;
          type = "lua";
          config = builtins.readFile ./lua/bufferline.lua;
      }
      {
          plugin = lualine-nvim;
          type = "lua";
          config = builtins.readFile ./lua/lualine.lua;
      }
      {
          plugin = nvim-treesitter.withAllGrammars;
          type = "lua";
          config = builtins.readFile ./lua/treesitter.lua;
      }
      (fromGitHub "main" "172027cccd3e657afc3b7e05552f5980e66d544e" "dariuscorvus/tree-sitter-surrealdb")
      {
          plugin = codeium-vim;
          type = "lua";
          config = builtins.readFile ./lua/codeium.lua;
      }
    ];
  };
}
