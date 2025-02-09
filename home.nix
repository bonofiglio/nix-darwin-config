{ pkgs, ... }:
{
  imports = [
    ./config/zsh.nix
    ./config/wezterm.nix
    ./config/gh.nix
  ];

  home.stateVersion = "22.05";

  # Set environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
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
    cargo-expand
    hyperfine # CLI benchmark
    m-cli # useful macOS CLI commands
    parallel
    ffmpeg
    cargo-cross # Cross compilation tool for cargo
    colima # Docker starter
    lighttpd
    p7zip
    rmtrash
    trash-cli
    nixpkgs-fmt
    bonofiglio-nixvim
    postgresql_16
    pkg-config
    libiconv
    ali
    nvd
    lldb_17
    llvmPackages_17.libllvm
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
    tart # Linux VMs in Apple Silicon
    deploy-rs
    act # Run GitHub actions locally
    sqlx-cli
    ttyplot

    # Languages
    llvmPackages_17.clang-unwrapped # Includes clangd lsp
    go
    nodejs_22
    (fenix.stable.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    bun
    deno

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
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          "AddKeysToAgent" = "yes";
          "UseKeychain" = "yes";
        };
      };
    };
  };
}
