{ pkgs, lib, ... }:
{
  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      return {
        default_prog = { '${lib.getExe pkgs.nushell}' },
        color_scheme = "Catppuccin Mocha",
        window_padding = {
          left = 5,
          right = 0,
          top = 1,
          bottom = 0,
        },
        window_decorations = "RESIZE",
        window_background_opacity = 0.95,
        font = wezterm.font("JetBrainsMonoNL Nerd Font", { weight = "Regular" }),
        font_size = 20.5,
        line_height = 1,
        adjust_window_size_when_changing_font_size = false,
        enable_kitty_keyboard = true,
        enable_scroll_bar = false,
        hide_tab_bar_if_only_one_tab = true,
        use_fancy_tab_bar = false,
        tab_bar_at_bottom = true,
        front_end = "WebGpu",
        scrollback_lines = 10000,
        max_fps = 120,
        animation_fps = 120,
        keys = {
          {
            key = 'LeftArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivateTabRelative(-1),
          },
          {
            key = 'RightArrow',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.ActivateTabRelative(1),
          },
          {
            key = ',',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.MoveTabRelative(-1),
          },
          {
            key = '.',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.MoveTabRelative(1),
          },
          {
            key = 'f',
            mods = 'CMD|SHIFT',
            action = wezterm.action.TogglePaneZoomState,
          },
          {
            key = 'v',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
          },
          {
            key = 'h',
            mods = 'CMD|SHIFT',
            action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
          },
          {
            key = 'w',
            mods = 'CMD|SHIFT',
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
          },
          {
            key = 'w',
            mods = 'CTRL|SHIFT',
            action = wezterm.action.CloseCurrentPane({ confirm = false }),
          },
          {
            key = 'LeftArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection("Left"),
          },
          {
            key = 'RightArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection("Right"),
          },
          {
            key = 'UpArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection("Up"),
          },
          {
            key = 'DownArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection("Down"),
          },
          {
            key = 'DownArrow',
            mods = 'CMD|SHIFT',
            action = wezterm.action.ActivatePaneDirection("Down"),
          },
          {
            key = 'k',
            mods = 'CMD',
            action = wezterm.action.ClearScrollback 'ScrollbackAndViewport',
          },
          {
            key = '0',
            mods = 'CTRL',
            action = wezterm.action.DisableDefaultAssignment,
          }
        }
      }
    '';
  };
}
