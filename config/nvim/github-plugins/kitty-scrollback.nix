{ pkgs, ... }:
(import ../../../lib/nvim-plugin-from-github.nix (pkgs)).nvimPluginFromGithub "main" "4ebe434f70e8ea75a87251d00323fa60d1e5a117" "mikesmithgh/kitty-scrollback.nvim"
