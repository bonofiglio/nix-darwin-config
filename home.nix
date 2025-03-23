{ pkgs, ... }:
{
  imports = [
    ./config/zsh.nix
    ./config/wezterm.nix
    ./config/gh.nix
    # Requires build to be done with path-type, since it's excluded from git
    # darwin-rebuild switch --flake path:.
    ./private
  ];

  home.stateVersion = "22.05";

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
    C_INCLUDE_PATH = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include";
    CPLUS_INCLUDE_PATH = "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk/usr/include";
  };

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # UI apps
    gimp
    qbittorrent
    battery
    moonlight-qt
    # hiddenbar
    # bitslicer
    blender
    unar # Unarchiver
    vscode # Live share has me by the b
    vlc
    android-file-transfer
    obsidian
    anki-bin
    feishin # Music player
    audacity

    # Window management
    rectangle
    raycast

    # Terminal tools
    neovim
    docker
    coreutils
    openssl
    pandoc # Document formatter
    texliveSmall
    jq
    jqp
    yq
    ripgrep # Required for NeoVim plugins
    taplo # TOML toolkit
    tmux
    tmate
    nodePackages.pnpm
    nodePackages.yarn
    hyperfine # CLI benchmark
    m-cli # useful macOS CLI commands
    parallel
    ffmpeg
    colima # Docker starter
    lighttpd
    p7zip
    rmtrash
    trash-cli
    nixpkgs-fmt
    pkg-config
    libiconv
    ali
    nvd
    # llvmPackages_14.libllvm
    # llvmPackages_14.bintools-unwrapped
    rclone
    turso-cli
    ninja
    cmake
    xdelta
    wrk
    xlsx2csv
    devenv
    iperf
    mtr
    gnugrep
    netcat-gnu
    deploy-rs
    sqlx-cli
    ttyplot
    ollama

    # Languages
    # llvmPackages_14.clang-unwrapped # Includes clangd lsp
    zigpkgs.master
    zls-latest
    go
    nodejs_22
    (fenix.latest.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
      "rustc-codegen-cranelift-preview"
    ])
    bun
    deno
    uv # python packager in rust

    # Databases
    sqlite
  ];

  # zoxide
  programs.zoxide = {
    enable = true;
    options = [
      "--cmd cd"
    ];
    enableZshIntegration = true;
  };

  # Git
  programs.git = {
    enable = true;
    package = pkgs.stable.git;
    userEmail = "dev@dan.uy";
    userName = "Daniel Bonofiglio";
    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com/" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  # SSH
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
