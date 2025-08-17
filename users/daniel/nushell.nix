{ pkgs, lib, ... }:
let
  e = lib.getExe;

  userConfig = ''
    $env.config.edit_mode = 'vi'
    $env.config.history.max_size = 50000
    $env.config.buffer_editor = "nvim"
    $env.config.rm.always_trash = true
    $env.config.use_kitty_protocol = true
    $env.config.show_banner = false
    $env.config.cursor_shape = {
      vi_insert: line
      vi_normal: block
      emacs: line
    }

    # Nix run shortcut
    def n [name: string] {
      nix run $"nixpkgs#($name)"
    }
  '';

  keybindings = ''
    $env.config.keybindings ++= [
      # Why isn't this default?
      {
        name: delete_one_word_backward
        modifier: alt
        keycode: backspace
        mode: vi_insert
        event: { edit: backspaceword }
      }

      # ESC sucks
      # {
      #   name: exit_insert_mode_with_ctrl_c
      #   modifier: control
      #   keycode: char_c
      #   mode: vi_insert
      #   event: {
      #     send: vichangemode
      #     mode: normal
      #   }
      # }

      # Vi motions for completions
      {
        name: select_right_completion_item_insert
        modifier: none
        keycode: char_l
        mode: vi_insert
        event: {
          until: [
            { send: menuright }
            {
              edit: insertstring
              value: "l"
            }
          ]
        }
      }

      {
        name: select_left_completion_item_insert
        modifier: none
        keycode: char_h
        mode: vi_insert
        event: {
          until: [
            { send: menuleft }
            {
              edit: insertstring
              value: "h"
            }
          ]
        }
      }

      {
        name: select_next_completion_item_insert
        modifier: none
        keycode: char_j
        mode: vi_insert
        event: {
          until: [
            { send: menudown }
            {
              edit: insertstring
              value: "j"
            }
          ]
        }
      }

      {
        name: select_prev_completion_item_insert
        modifier: none
        keycode: char_k
        mode: vi_insert
        event: {
          until: [
            { send: menuup }
            {
              edit: insertstring
              value: "k"
            }
          ]
        }
      }
    ]
  '';

  completerConfig = ''
    let fish_completer = {|spans|
        ${e pkgs.fish} --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
        | from tsv --flexible --noheaders --no-infer
        | rename value description
        | update value {|row|
          let value = $row.value
          let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
          if ($need_quote and ($value | path exists)) {
            let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
            $'"($expanded_path | str replace --all "\"" "\\\"")"'
          } else {$value}
        }
    }

    let carapace_completer = {|spans: list<string>|
        ${e pkgs.carapace} $spans.0 nushell ...$spans
        | from json
        | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
    }

    # This completer will use carapace by default
    let external_completer = {|spans|
        let expanded_alias = scope aliases
        | where name == $spans.0
        | get -o 0.expansion

        let spans = if $expanded_alias != null {
            $spans
            | skip 1
            | prepend ($expanded_alias | split row ' ' | take 1)
        } else {
            $spans
        }

        match $spans.0 {
            # carapace completions are incorrect for nu
            nu => $fish_completer
            # fish completes commits and branch names in a nicer way
            git => $fish_completer
            # carapace doesn't have completions for tmuxifier
            tmuxifier => $fish_completer
            _ => $carapace_completer
        } | do $in $spans
    }

    $env.config.completions.external = {
      enable: true
      completer: $external_completer
    }
  '';

  environmentVariables = ''
    $env.EDITOR = "nvim"
    $env.__NIX_DARWIN_SET_ENVIRONMENT_DONE = 1 
    $env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
    $env.HOMEBREW_PREFIX = "/opt/homebrew"
    $env.HOMEBREW_REPOSITORY = "/opt/homebrew"
    $env.INFOPATH = "/opt/homebrew/share/info:"
    $env.PATH = [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
      "/opt/local/bin"
      "/opt/local/sbin"
      $"($env.HOME)/.nix-profile/bin"
      $"/etc/profiles/per-user/($env.USER)/bin"
      "/run/current-system/sw/bin"
      "/nix/var/nix/profiles/default/bin"
      "/usr/local/bin"
      "/usr/bin"
      "/bin"
      "/usr/sbin"
      "/sbin"
    ]
    $env.NIX_PATH = [
        $"darwin-config=($env.HOME)/.nixpkgs/darwin-configuration.nix"
        "/nix/var/nix/profiles/per-user/root/channels"
    ]
    $env.NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
    $env.PAGER = "less -R"
    $env.TERMINFO_DIRS = [
        $"($env.HOME)/.nix-profile/share/terminfo"
        $"/etc/profiles/per-user/($env.USER)/share/terminfo"
        "/run/current-system/sw/share/terminfo"
        "/nix/var/nix/profiles/default/share/terminfo"
        "/usr/share/terminfo"
    ]
    $env.XDG_CONFIG_DIRS = [
        $"($env.HOME)/.nix-profile/etc/xdg"
        $"/etc/profiles/per-user/($env.USER)/etc/xdg"
        "/run/current-system/sw/etc/xdg"
        "/nix/var/nix/profiles/default/etc/xdg"
    ]
    $env.XDG_DATA_DIRS = [
        $"($env.HOME)/.nix-profile/share"
        $"/etc/profiles/per-user/($env.USER)/share"
        "/run/current-system/sw/share"
        "/nix/var/nix/profiles/default/share"
    ]
    $env.TERM = $env.TERM
    $env.NIX_USER_PROFILE_DIR = $"/nix/var/nix/profiles/per-user/($env.USER)"
    $env.NIX_PROFILES = [
        "/nix/var/nix/profiles/default"
        "/run/current-system/sw"
        $"/etc/profiles/per-user/($env.USER)"
        $"($env.HOME)/.nix-profile"
    ]

    if ($"($env.HOME)/.nix-defexpr/channels" | path exists) {
        $env.NIX_PATH = ($env.PATH | split row (char esep) | append $"($env.HOME)/.nix-defexpr/channels")
    }

    if (false in (ls -l `/nix/var/nix`| where type == dir | where name == "/nix/var/nix/db" | get mode | str contains "w")) {
        $env.NIX_REMOTE = "daemon"
    }
  '';

  bonofiglioNushell = pkgs.rustPlatform.buildRustPackage {
    pname = "nushell";
    version = "bonofiglio";

    src = pkgs.fetchFromGitHub {
      owner = "bonofiglio";
      repo = "nushell";
      rev = "8d6abc3212ebc8de0226222ee57d7dbfba5659fd";
      hash = "sha256-KQe1fssvx53WgGjotJTQhF2eiDullGPjiRQeaf0DDYA=";
    };

    cargoHash = "sha256-T9uyLuS4TvTC5Jyc1izddmtNlqIPdB5Yqi9yzVI8POw=";

    nativeBuildInputs = [
      pkgs.pkg-config
      pkgs.rustPlatform.bindgenHook
    ];

    buildInputs = [
      pkgs.openssl
      pkgs.zstd
      pkgs.zlib
      pkgs.nghttp2
      pkgs.libgit2
    ];

    buildFeatures = [ ];

    checkPhase = ''
      runHook preCheck
      (
        # The skipped tests all fail in the sandbox because in the nushell test playground,
        # the tmp $HOME is not set, so nu falls back to looking up the passwd dir of the build
        # user (/var/empty). The assertions however do respect the set $HOME.
        set -x
        HOME=$(mktemp -d) cargo test -j $NIX_BUILD_CORES --offline -- \
          --test-threads=$NIX_BUILD_CORES \
          --skip=repl::test_config_path::test_default_config_path \
          --skip=repl::test_config_path::test_xdg_config_bad \
          --skip=repl::test_config_path::test_xdg_config_empty
      )
      runHook postCheck
    '';

    checkInputs = [
      pkgs.curlMinimal
    ];

    passthru = {
      shellPath = "/bin/nu";
    };

    meta = with lib; {
      description = "Modern shell written in Rust";
      homepage = "https://www.nushell.sh/";
      license = licenses.mit;
      maintainers = with maintainers; [
        Br1ght0ne
        johntitor
        joaquintrinanes
        ryan4yin
      ];
      mainProgram = "nu";
    };
  };
in
{
  programs.nushell = {
    enable = true;
    # package = bonofiglioNushell;
    configFile.text = ''
      ${userConfig}
      ${keybindings}
      ${completerConfig}
      ${environmentVariables}
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}
