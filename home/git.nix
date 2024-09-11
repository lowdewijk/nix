{ config, pkgs, ...}:

{
  programs.git = {
    enable = true;
    userName = "Lodewijk Bogaards";
    userEmail = "lodewijk.bogaards@gmail.com";

    package = pkgs.gitFull;

    # Install and setup delta (https://github.com/dandavison/delta)
    delta = {
      enable = true;
      options = {
        # See available themes with `delta --list-syntax-themes`
        syntax-theme = "Solarized (dark)";
      };
    };

    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      core = {
        editor = "${pkgs.lib.getExe pkgs.neovim}";
      };
      color = {
        ui = "auto";
      };
      diff = {
        algorithm = "histogram";
        tool = "${pkgs.lib.getExe pkgs.neovim} -d";
      };
      # Guesses what I mean when I make a mistake
      help = {
        autocorrect = "prompt";
      };
      commit = {
        # Show full diff when running `git commit`
        verbose = true;
      };
      # Push to branch origin/whatever_my_current_branch_is if no upstream branch is set
      push = {
        default = "current";
      };
      # Always `git pull --rebase`.
      pull = {
        rebase = true;
      };
      # Better diff style
      merge = {
        conflictstyle = "zdiff3";
      };
      # Helpful for rebases
      rebase = {
        autosquash = true;
        autostash = true;
      };
      # Run some validation on Git objects to prevent weirdness from occuring
      transfer = {
        fsckobjects = true;
      };
      fetch = {
        fsckobjects = true;
      };
      receive = {
        fsckObjects = true;
      };
    };

    # List of paths that should be globally ignored
    # While those files are usually never tracked, adding them is still possible with `git add --force filename`
    ignores = [
      "*.swp"
      ".direnv/"
    ];
    aliases = {
      s = "status";
      d = "diff";
      p = "push";
      unadd = "reset HEAD --";
      c = "commit";
      last = "log -1 HEAD";
    };
  };
}
