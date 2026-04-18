{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let
  e = lib.getExe;
  jj = e config.programs.jujutsu.package;
  carapace = e config.programs.carapace.package;
  fish = e pkgs.fish;

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
    def --wrapped n [name: string, ...args: string] {
      let nixpkgs = "${inputs.nixpkgs.outPath}"

      if ($name | str contains "/") {
        let parts = ($name | split row "/")
        let pkg = $parts.0
        let cmd = $parts.1

        nix shell --impure $"($nixpkgs)#($pkg)" -c $cmd ...$args
      } else {
        nix run --impure $"$($nixpkgs)#($name)" -- ...$args
      }
    }

    def --wrapped ns [name: string, ...args: string] {
      let nixpkgs = "${inputs.nixpkgs.outPath}"

      if ($name | str contains "/") {
        let parts = ($name | split row "/")
        let pkg = $parts.0
        let cmd = $parts.1

        nix shell $"($nixpkgs)#($pkg)" -c $cmd ...$args
      } else {
        nix run $"$($nixpkgs)#($name)" -- ...$args
      }
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
      {
        name: exit_insert_mode_with_ctrl_c
        modifier: control
        keycode: char_c
        mode: vi_insert
        event: {
          send: vichangemode
          mode: normal
        }
      }

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
        ${fish} --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
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
        ${carapace} $spans.0 nushell ...$spans
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
in
{
  programs.nushell = {
    enable = true;
    configFile.text = ''
      ${userConfig}
      ${keybindings}
      ${completerConfig}
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
      custom.jj = {
        format = "on [$symbol]($style) $output";
        symbol = "";
        style = "bold purple";
        shell = [
          "sh"
          "--norc"
          "--noprofile"
        ];
        command = ''
          ${jj} log --revisions @ --limit 1 --ignore-working-copy --no-graph --color always  --template '
            separate(" ",
              change_id.shortest(6),
              tags.map(|x| truncate_end(10, x.name(), "…")).join(" "),
              bookmarks.map(|x| truncate_end(10, concat(x.name(), if(!x.synced(), "*")), "…")).join(" "),
              if(bookmarks.len() > 0, label("rest", "|")),
              if(description,
                label(
                  if(
                    bookmarks.any(|x| !x.synced()),
                    "working_copy",
                    "default"
                  ),
                  truncate_end(50, description.first_line(), "…")
                ),
              ),
              if(conflict, "conflict"),
              if(divergent, "divergent"),
              if(hidden, "hidden"),
            )
          '
        '';
        when = "jj --ignore-working-copy root";
        description = "The current jj status";
      };
      git_status.disabled = true;
      custom.git_status = {
        when = "! jj --ignore-working-copy root";
        command = "starship module git_status";
        description = "Only show git_status if we're not in a jj repo";
        style = "";
      };
      git_branch.disabled = true;
      custom.git_branch = {
        when = "! jj --ignore-working-copy root";
        command = "starship module git_branch";
        description = "Only show git_branch if we're not in a jj repo";
        style = "";
      };
      format = lib.concatStrings [
        "$directory"
        "\${custom.jj}"
        "$git_branch"
        "$line_break"
        "$character"
      ];
    };
  };
}
