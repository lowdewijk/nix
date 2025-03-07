{pkgs, ...}: {
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.catppuccin.enable = true;
    autocd = true;

    shellAliases = {
      switch = "~/nixos/nixos-rebuild.sh switch";

      v = "nvim";

      l = "eza -l --icons";
      ls = "eza";
      ll = "eza -l --icons";
      la = "eza -a --icons";
      lla = "eza -al --icons";
      lt = "eza -tree --icons";
      ltl = "eza -tree -l --icons";

      cat = "bat";
      ga = "git add -A";
      gs = "git status";
      gd = "git diff";
      gc = "git commit";
      gcm = "git commit -m";
      gp = "git push";
      gl = "git log";
      cpv = "rsync --info=progress2 --human-readable --no-inc-recursive";

      # ask chatgpt a question
      # populates environment variables with 1password
      q = "OPENAI_API_KEY=op://Personal/OpenAI/api-keys/terminal-api-key op run -- aichat";
    };
    completionInit = "autoload -U compinit && compinit -i";
    initExtra = ''
      # so tmux knows that it should start in this shell
      export SHELL=$(which zsh)

      # remove API_annoying message when * result in no match
      setopt +o nomatch

      # setup starship and direnv
      eval "$(starship init zsh)"
      eval "$(direnv hook zsh)"

      # run neofetch the first time a console is started
      LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi -e "tty*" -e "?" | uniq | wc -l);
      if [ $LIVE_COUNTER -eq 1 ]; then
        neofetch
      fi

      # makes backward behave the way you want it with respect to line breaks
      # https://unix.stackexchange.com/questions/206853/setting-backspace-2-in-zsh-with-vi-bindings
      bindkey -v '^?' backward-delete-char

      # run extra zshrc that is not managed by this project
      if [ -f "$HOME/.extra_zshrc" ]; then
        source "$HOME/.extra_zshrc"
      fi
    '';
    history = {
      extended = true;
      size = 10000;
    };
    sessionVariables = {
      # Suppress direnv logs
      DIRENV_LOG_FORMAT = "";

      # Don't use nano
      EDITOR = "nvim";

      NIXPKGS_ALLOW_UNFREE = 1;
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        src = pkgs.zsh-nix-shell;
        # name of the file needs to map to what is sourced in ~/.zhsrc
        file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      }
      {
        name = "nix-zsh-completions";
        src = pkgs.nix-zsh-completions;
        file = "share/zsh/plugins/nix/nix-zsh-completions.plugin.zsh";
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
        file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      }
      {
        name = "zsh-z";
        src = pkgs.zsh-z;
        file = "share/zsh-z/zsh-z.plugin.zsh";
      }
      {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        # name of the file needs to map to what is sourced in ~/.zhsrc
        file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
      }
      {
        name = "bd";
        src = pkgs.zsh-bd;
        # name of the file needs to map to what is sourced in ~/.zhsrc
        file = "share/zsh-bd/bd.plugin.zsh";
      }
    ];
  };
}
