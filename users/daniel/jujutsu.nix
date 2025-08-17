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
      revsets.log = "@ | ancestors(trunk()..(visible_heads() & mine()), 2) | trunk()";
    };
  };
}
