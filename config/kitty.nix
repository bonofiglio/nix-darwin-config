{ pkgs, ... }:
let
  kittyScrollbackNvim = import ./nvim/github-plugins/kitty-scrollback.nix (pkgs);
in
{
  programs.kitty = {
    enable = true;

    extraConfig = ''
      map cmd+t no_op
      map cmd+t launch --cwd=current --type=tab

      window_padding_width 0 0 5 1

      tab_bar_min_tabs            1
      tab_bar_edge                bottom
      tab_bar_style               powerline
      tab_powerline_style         slanted

      enabled_layouts tall:bias=50;full_size=1;mirrored=false
      map ctrl+[ layout_action decrease_num_full_size_windows
      map ctrl+] layout_action increase_num_full_size_windows

      allow_remote_control socket-only
      listen_on unix:/tmp/kitty
      shell_integration enabled

      # kitty-scrollback.nvim Kitten alias
      action_alias kitty_scrollback_nvim kitten '' + kittyScrollbackNvim + ''/python/kitty_scrollback_nvim.py

        # Browse scrollback buffer in nvim
        map ctrl+shift+h kitty_scrollback_nvim --nvim-args "--noplugin --clean -n" --env KITTY_SCROLLBACK=1
      '';
    font = {
      name = "JetBrainsMonoNL Nerd Font";
      size = 20;
    };
    theme = "Catppuccin-Mocha";
  };
}
