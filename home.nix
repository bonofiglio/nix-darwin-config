{ config, pkgs, lib, ... }:
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

  programs.zsh.enable = true;
  programs.zsh.enableCompletion = false;
  
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # UI apps
    docker
    gimp
    zoom-us
    discord

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

    # Laguages
    llvmPackages_16.clang-unwrapped # Includes clangd lsp
    python312
    go
    nodejs_20
    cargo
    rustc

    # LSPs
    gotools
    gopls
    rust-analyzer
    rustfmt
    vscode-langservers-extracted
    nodePackages.typescript-language-server
    nodePackages.svelte-language-server
    nodePackages.volar
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.yaml-language-server
    nodePackages.bash-language-server
    docker-compose-language-service
    lua-language-server

    sqlite
  ] ++ lib.optionals stdenv.isDarwin [
    m-cli # useful macOS CLI commands
  ];

  # Git
  programs.git = {
    enable = true;
    userEmail = "dev@dan.uy";
    userName = "Daniel Bonofiglio";
  };

  # LazyGit
  programs.lazygit.enable = true;

  # Kitty
  programs.kitty = {
      enable = true;
      extraConfig = ''
        map cmd+t no_op
        map cmd+t launch --cwd=current --type=tab
      '';
      font = {
        name = "JetBrainsMonoNL Nerd Font Mono";
        size = 20;
      };
  };
}
