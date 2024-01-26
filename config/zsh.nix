{ pkgs, ... }:
{
  programs.zsh = {
      enable = true;
      enableCompletion = true;
      defaultKeymap = "viins";
      shellAliases = {
          rm = "rmtrash";
      };
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
          # Yank to the system clipboard
          function zvm_vi_yank() {
              zvm_yank
              echo ''${CUTBUFFER} | pbcopy
              zvm_exit_visual_mode
          }

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
}
  
