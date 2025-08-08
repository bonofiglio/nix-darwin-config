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
    };
  };
}
