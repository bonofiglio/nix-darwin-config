{ pkgs, lib, ... }:
{
  programs.tmux = {
    enable = true;
    keyMode = "vi";
    extraConfig = ''
      # Set the prefix to a more comfy keybind (split keyboard only)
      set -g prefix C-a
      # Enable noob mode
      set -g mouse on
      set -g default-terminal "xterm-256color"

      # Reorder windows when closing windows to avoid crippling depression and gaps in the numbers
      set-option -g renumber-windows on

      # Make status bar respect transparency
      set -g status-style bg=default

      set -g default-shell ${lib.getExe pkgs.nushell}

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

      # Set new panes and splits to open in current directory
      bind c new-window -c "#{pane_current_path}"
      bind '"' split-window -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
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
      tmuxPlugins.better-mouse-mode
      tmuxPlugins.vim-tmux-navigator
    ];
  };
}
