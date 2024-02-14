{ pkgs, ... }:
{
  imports = [
    ./config/zsh.nix
    ./config/wezterm.nix
    ./config/kitty.nix
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
    zoom-us
    discord
    qbittorrent
    height
    craft
    dbeaver

    # hiddenbar
    # bitslicer
    blender
    unar # Unarchiver
    vscode # Live share has me by the b
    vlc
    android-file-transfer
    obsidian
    anki-bin

    # Web browsers
    firefox

    # Window management
    rectangle
    raycast

    # Terminal tools
    docker
    coreutils
    openssl
    pandoc # Document formatter
    jq
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

    # Languages
    llvmPackages_17.clang-unwrapped # Includes clangd lsp
    go
    nodejs_20
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
    surrealdb
  ];

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

  # LazyGit
  programs.lazygit.enable = true;

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
