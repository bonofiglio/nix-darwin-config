{ ... }:
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
        "difft"
        "--color=always"
        "$left"
        "$right"
      ];
      revsets.log = "@ | ancestors(trunk()..(visible_heads() & mine()), 2) | trunk()";
    };
  };
}
