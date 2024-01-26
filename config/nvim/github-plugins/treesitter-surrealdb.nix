{ pkgs, ... }:
(import ../../../lib/nvim-plugin-from-github.nix(pkgs)).nvimPluginFromGithub "main" "172027cccd3e657afc3b7e05552f5980e66d544e" "dariuscorvus/tree-sitter-surrealdb"
