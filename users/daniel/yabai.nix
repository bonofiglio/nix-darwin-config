{
  config,
  pkgs,
  ...
}:
let
  agentName = "yabai";
  yabai = "${pkgs.yabai}/bin/yabai";
in
{
  xdg.configFile."yabai/yabairc" = {
    enable = true;
    executable = true;
    text = ''
      ${yabai} -m config external_bar              all:40:0
      ${yabai} -m config menubar_opacity           1.0
      ${yabai} -m config mouse_follows_focus       on
      ${yabai} -m config focus_follows_mouse       autoraise
      ${yabai} -m config display_arrangement_order default
      ${yabai} -m config window_origin_display     default
      ${yabai} -m config window_placement          second_child
      ${yabai} -m config window_insertion_point    focused
      ${yabai} -m config window_zoom_persist       on
      ${yabai} -m config window_shadow             off
      ${yabai} -m config window_animation_duration 0.15
      ${yabai} -m config window_animation_easing   ease_out_circ
      ${yabai} -m config window_opacity_duration   0.1
      ${yabai} -m config active_window_opacity     1.0
      ${yabai} -m config normal_window_opacity     0.98
      ${yabai} -m config window_opacity            off
      ${yabai} -m config insert_feedback_color     0xffd75f5f
      ${yabai} -m config split_ratio               0.50
      ${yabai} -m config split_type                auto
      ${yabai} -m config auto_balance              off
      ${yabai} -m config top_padding               8
      ${yabai} -m config bottom_padding            8
      ${yabai} -m config left_padding              8
      ${yabai} -m config right_padding             8
      ${yabai} -m config window_gap                10
      ${yabai} -m config layout                    bsp
      ${yabai} -m config mouse_modifier            alt
      ${yabai} -m config mouse_action1             move
      ${yabai} -m config mouse_action2             resize
      ${yabai} -m config mouse_drop_action         swap

      ${yabai} -m signal --add event=dock_did_restart action="/usr/bin/sudo ${yabai} --load-sa"

      # bar configuration
      ${yabai} -m signal --add event=window_focused   action="${pkgs.sketchybar}/bin/sketchybar --trigger window_focus"
      ${yabai} -m signal --add event=window_created   action="${pkgs.sketchybar}/bin/sketchybar --trigger windows_on_spaces"
      ${yabai} -m signal --add event=window_destroyed action="${pkgs.sketchybar}/bin/sketchybar --trigger windows_on_spaces"

      # rules
      ${yabai} -m rule --add app="^System Settings$"    manage=off
      ${yabai} -m rule --add app="^System Information$" manage=off
      ${yabai} -m rule --add app="^System Preferences$" manage=off
      ${yabai} -m rule --add title="Preferences$"       manage=off
      ${yabai} -m rule --add title="Settings$"          manage=off

      # workspace management
      ${yabai} -m space 1 --label chat
      ${yabai} -m space 2 --label term
      ${yabai} -m space 3 --label browser
      ${yabai} -m space 4 --label work
      ${yabai} -m space 5 --label management
      ${yabai} -m space 6 --label "work browser"
      ${yabai} -m space 7 --label music
      ${yabai} -m space 8 --label sql
      ${yabai} -m space 9 --label obsidian
    '';

    onChange = ''
      /bin/launchctl bootout gui/$(id -u ${config.home.username}) ${config.home.homeDirectory}/Library/LaunchAgents/org.nix-community.home.${agentName}.plist 2> /dev/null || true
      pkill yabai || true
      /bin/launchctl bootstrap gui/$(id -u ${config.home.username}) ${config.home.homeDirectory}/Library/LaunchAgents/org.nix-community.home.${agentName}.plist 2> /dev/null
      sudo ${yabai} --load-sa
    '';
  };

  home.packages = [ pkgs.yabai ];

  # Use custom yabai agent because nix-darwin's module is unreliable at boot
  launchd.agents.${agentName} = {
    enable = true;
    config = {
      ProcessType = "Interactive";
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.yabai} && exec ${pkgs.yabai}/bin/yabai -c ${
          config.xdg.configFile."yabai/yabairc".source
        }"
      ];
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/yabai/yabai.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/yabai/yabai.err.log";
    };
  };

  launchd.agents.yabai-sa = {
    enable = true;
    config = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "/bin/wait4path ${pkgs.yabai} && exec /usr/bin/sudo ${pkgs.yabai}/bin/yabai --load-sa"
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/yabai/yabai-sa.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/yabai/yabai-sa.err.log";
    };
  };
}
