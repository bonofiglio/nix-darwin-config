{ pkgs, ... }:
{
    nvimPluginFromGithub = ref: rev: repo: pkgs.vimUtils.buildVimPlugin {
        pname = "${pkgs.lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = builtins.fetchGit {
            url = "https://github.com/${repo}.git";
            ref = ref;
            rev = rev;
        };
    };
}
