{ pkgs, lib, ... }:
let
  tmuxPackage = pkgs.tmux.overrideAttrs (old: {
    version = "git"; # usually harmless to omit
    src = pkgs.fetchFromGitHub {
      owner = "tmux";
      repo = "tmux";
      rev = "7e439539377e272f37d18bb10dbff374b87acee6";
      hash = "sha256-YY9CJ2Z6hjC4kGjRswlps4hya5Lk/ksM9luJHW8Cags=";
    };
  });
in
{
  programs.tmux = {
    enable = true;
    package = tmuxPackage;
    keyMode = "vi";
    extraConfig = ''
      # Set the prefix to a more comfy keybind (split keyboard only)
      set -g prefix C-a
      # Enable noob mode
      set -g mouse on
      set -g default-terminal "xterm-256color"

      # Enable fancy terminal stuff
      set -s extended-keys on
      set -as terminal-features 'xterm*:extended-keys'
      set -g focus-events on

      # Extend history limit
      set -g history-limit 50000

      # Move between panes like it's vim
      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Remove prefix for navigating windows
      bind-key -n C-p previous-window
      bind-key -n C-n next-window

      # Adds control before normal tmux bindings
      bind-key C-w choose-window
      bind-key C-s choose-session
      bind-key C-x confirm-before -p "kill-window #W? (y/n)" kill-window
      bind-key C-c new-window
    '';
    plugins = with pkgs; [
      {
        plugin = tmuxCustomPlugins.catppuccin;
        extraConfig = ''
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""
          set -g @catppuccin_flavor 'mocha'
          set -g @catppuccin_window_status_style 'rounded'
          set -g @catppuccin_window_text ' #W'
          set -g @catppuccin_window_current_text ' #W'
          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
        '';
      }
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.better-mouse-mode
    ];
  };
}
