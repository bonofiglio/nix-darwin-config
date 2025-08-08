{
  pkgs,
  lib,
  custLib,
  ...
}:
let
  exe = lib.meta.getExe;
  inherit (custLib) ifDarwinAttrs;
in
{
  # Direnv, load and unload environment variables depending on the current directory.
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Set environment variables
  home.sessionVariables = {
    EDITOR = exe pkgs.neovim;
  }
  // ifDarwinAttrs {
    C_INCLUDE_PATH = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include";
    CPLUS_INCLUDE_PATH = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include";
  };

  # Essential software
  home.packages =
    with pkgs;
    [
      coreutils
      fzf
      jq
      neovim
      nixfmt-rfc-style
      openssl
      rclone
      ripgrep
      sqlx-cli
    ]
    # Bitwarden CLI is currently broken on darwin
    ++ lib.optionals pkgs.stdenv.isLinux [
      bitwarden-cli
    ];

  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.stable.git;
    userEmail = "dev@dan.uy";
    userName = "Daniel Bonofiglio";
    extraConfig = {
      init.defaultBranch = "main";
      # Always use SSH clone to avoid permission issues
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          "AddKeysToAgent" = "yes";
          "UseKeychain" = "yes";
        };
      };
    };
  };
}
