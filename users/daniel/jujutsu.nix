{ config, lib, ... }:
let
  difftCommand = lib.getExe config.programs.difftastic.package;
in
{
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        email = "dev@dan.uy";
        name = "Daniel Bonofiglio";
      };
      ui.paginate = "never";
      ui.editor = "nvim --noplugin";
      ui.diff-formatter = [
        difftCommand
        "--color=always"
        "$left"
        "$right"
      ];
      revsets.log = "@ | ancestors(trunk()..(visible_heads() & mine()), 2) | trunk()";
    };
  };
}
