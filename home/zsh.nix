{ config, pkgs, ...}:

{
  programs.zsh = {
     enable = true;

     enableCompletion = true;
     syntaxHighlighting.enable = true;
     autocd = true;

     shellAliases = {
       v = "nvim";
       ls = "eza";
       ll = "eza -l";
       tree = "eza --tree";
       cat = "bat";
       g = "git";
       gc = "git c";
       gs = "git s";
       ga = "git add -A";
     };
     completionInit = "autoload -U compinit && compinit -i";
     initExtra = ''
       setopt +o nomatch
       eval "$(starship init zsh)"
     '';
     history = {
       extended = true;
       size = 10000;
     };
    plugins = [
      {
        name = "nix-zsh-completions";
        src = "${pkgs.nix-zsh-completions}/share/zsh/site-functions";
      }
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
