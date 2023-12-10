{ pkgs, ... }:
let 
kittyScrollbackNvim = import ./nvim/github-plugins/kitty-scrollback.nix(pkgs);
in
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
      initExtra = ''
          source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.zsh
          # Replace the vi insert escape key with ^C by changing it to ^E and
          # changing it back to ^C when a command is executed
          precmd() {
              stty intr \^E
          }
          preexec() {
              stty intr \^C
          }
          ZVM_VI_INSERT_ESCAPE_BINDKEY=^C

          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

          source ${pkgs.zsh-history-substring-search}/share/zsh-history-substring-search/zsh-history-substring-search.zsh
          bindkey -M viins '^[[A' history-substring-search-up
          bindkey -M viins '^[[B' history-substring-search-down
          bindkey -M vicmd '^[[A' history-substring-search-up
          bindkey -M vicmd '^[[B' history-substring-search-down
          bindkey -M vicmd 'k' history-substring-search-up
          bindkey -M vicmd 'j' history-substring-search-down
      '';
  };
  
  programs.nix-index.enable = true;

  home.packages = with pkgs; [
    # UI apps
    gimp
    zoom-us
    discord
    qbittorrent
    height
    craft
    blender
    unar # Unarchiver
    vscode # Live share has me by the b
    vlc
    android-file-transfer
    obsidian

    # Web browsers
    firefox
    ungoogled-chromium

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
    sc-im # Spreadsheet viewer

    # Languages
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

        allow_remote_control socket-only
        listen_on unix:/tmp/kitty
        shell_integration enable

        # kitty-scrollback.nvim Kitten alias
        action_alias kitty_scrollback_nvim kitten '' + kittyScrollbackNvim + ''/python/kitty_scrollback_nvim.py --cwd '' + kittyScrollbackNvim + ''/lua/kitty-scrollback/configs --nvim-args "--noplugin -n" --env KITTY_SCROLLBACK=1

        # Browse scrollback buffer in nvim
        map ctrl+shift+h kitty_scrollback_nvim
      '';
      font = {
        name = "JetBrainsMonoNL Nerd Font";
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
