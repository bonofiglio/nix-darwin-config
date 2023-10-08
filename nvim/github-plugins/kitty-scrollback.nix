{ pkgs, ... }:
(import ../../lib/nvim-plugin-from-github.nix(pkgs)).nvimPluginFromGithub "main" "31460e47816bffeda5d21f4e3b47720785ba2c94" "mikesmithgh/kitty-scrollback.nvim"
