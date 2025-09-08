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
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    config.global.log_filter = "^loading";

    enableZshIntegration = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
  };

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
      btop
      parallel
      coreutils
      fzf
      jq
      neovim
      nixfmt-rfc-style
      openssl
      rclone
      ripgrep
      gcc
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
    settings = {
      user.email = "dev@dan.uy";
      user.name = "Daniel Bonofiglio";
      init.defaultBranch = "main";
      # Always use SSH clone to avoid permission issues
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
    git.diffToolMode = true;
    options.color = "always";
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        forwardAgent = false;
        addKeysToAgent = "yes";
        compression = false;
        serverAliveInterval = 0;
        serverAliveCountMax = 3;
        hashKnownHosts = false;
        userKnownHostsFile = "~/.ssh/known_hosts";
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
      };

      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = ifDarwinAttrs {
          "AddKeysToAgent" = "yes";
          "UseKeychain" = "yes";
        };
      };
    };
  };
}
