{ pkgs, ... }:
{
  imports = [
    ./nvim
  ];

  home.stateVersion = "22.05";

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      completionInit = ''
          autoload -U compinit 
          compinit -u
      '';
  };
  
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # UI apps
    docker
    gimp
    zoom-us
    discord
    qbittorrent

    # Window management
    rectangle
    raycast

    # Terminal tools
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

    # Laguages
    llvmPackages_16.clang-unwrapped # Includes clangd lsp
    python312
    go
    nodejs_20
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    bun
    deno

    # LSPs
    gotools
    gopls
    rust-analyzer-nightly
    vscode-langservers-extracted
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages.volar
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    docker-compose-language-service
    lua-language-server
    nil

    sqlite
  ];

  # Git
  programs.git = {
    enable = true;
    userEmail = "dev@dan.uy";
    userName = "Daniel Bonofiglio";
    extraConfig = {
        url = {
            "ssh://git@github.com/" = {
                insteadOf = "https://github.com/";
            };
        };
    };
  };

  # LazyGit
  programs.lazygit.enable = true;

  # Kitty
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
      '';
      font = {
        name = "JetBrainsMonoNL Nerd Font Mono";
        size = 20;
      };
      theme = "Catppuccin-Mocha";
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
