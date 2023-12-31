{ pkgs, ... }:
let 
    treesitterSurreal = import ./github-plugins/treesitter-surrealdb.nix(pkgs);
    kittyScrollback = import ./github-plugins/kitty-scrollback.nix(pkgs);
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraLuaConfig = builtins.readFile ./lua/settings.lua;
    package = pkgs.neovim-unwrapped;
    plugins = with pkgs.vimPlugins; [
      neodev-nvim
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
          config = builtins.readFile ./lua/fugitive.lua;
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
      {
          plugin = nvim-treesitter-context;
          type = "lua";
          config = builtins.readFile ./lua/treesitter-context.lua;
      }
      treesitterSurreal
      {
          plugin = nvim-ts-autotag;
          type = "lua";
          config = "require('nvim-ts-autotag').setup()";
      }
      {
          plugin = codeium-vim;
          type = "lua";
          config = builtins.readFile ./lua/codeium.lua;
      }
      {
          plugin = kittyScrollback;
          type = "lua";
          config = "require('kitty-scrollback').setup()";
      }
    ];
  };
}
