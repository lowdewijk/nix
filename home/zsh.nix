{ config, pkgs, ...}:

{
  programs.zsh = {
     enable = true;

     enableCompletion = true;
     syntaxHighlighting.enable = true;
     syntaxHighlighting.catppuccin.enable = true;
     autocd = true;

     shellAliases = {
       v = "nvim";
       ls = "eza";
       ll = "eza -l";
       tree = "eza --tree";
       cat = "bat";
       ga = "git add -A";
       gs = "git status";
       gd = "git diff";
       gc = "git commit";
       gcm = "git commit -m";
       gp = "git push";
     };
     completionInit = "autoload -U compinit && compinit -i";
     initExtra = ''
        setopt +o nomatch
        eval "$(starship init zsh)"

        # run neofetch the first time a console is started
        LIVE_COUNTER=$(ps a | awk '{print $2}' | grep -vi -e "tty*" -e "?" | uniq | wc -l);
        if [ $LIVE_COUNTER -eq 1 ]; then
          neofetch
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
    };
    plugins = [
      {
        name = "nix-shell";
        src = "${pkgs.zsh-nix-shell}/share/zsh/site-functions";
      }
      {
        name = "nnn-quitcd";
        file = "share/quitcd/quitcd.bash_sh_zsh";
        src = pkgs.nnn;
      }
      {
        name = "vi-mode";
        src = pkgs.zsh-vi-mode;
        file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
      }
      rec {
        name = "you-should-use";
        src = pkgs.zsh-you-should-use;
        file = "share/zsh/plugins/${name}/${name}.plugin.zsh";
      }
      rec {
        name = "bd";
        src = pkgs.zsh-bd;
        file = "share/zsh-${name}/${name}.plugin.zsh";
      }
    ];
 };

}
