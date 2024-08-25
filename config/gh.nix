{ pkgs, ... }:
{
  # Github CLI
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
    extensions = with pkgs; [ gh-actions-cache ];
  };

  programs.gh-dash = {
    enable = true;
    settings = {
      prSections = [
        { title = "My Pull Requests"; filters = "is:open author:@me"; layout = { author = { hidden = true; }; }; }
        { title = "Needs My Review"; filters = "is:open review-requested:@me"; }
        { title = "Tailor"; filters = "is:open owner:tailor-commerce"; limit = 50; }
      ];
      issuesSections = [
        { title = "Created"; filters = "is:open author:@me"; }
        { title = "Assigned"; filters = "is:open assignee:@me"; }
      ];
      defaults = {
        layout.prs.repo = { grow = true; width = 10; hidden = false; };
        prsLimit = 20;
        issuesLimit = 20;
        preview = { open = true; width = 60; };
        refetchIntervalMinutes = 30;
      };
    };
  };
}
