{...}: {
  programs.nushell = {
    enable = true;
    configFile.text = ''
      use std/config *

      $env.config.edit_mode = 'vi'

      # Initialize the PWD hook as an empty list if it doesn't exist
      $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

      $env.config.hooks.env_change.PWD ++= [{||
        if (which direnv | is-empty) {
          # If direnv isn't installed, do nothing
          return
        }

        direnv export json | from json | default {} | load-env
        # If direnv changes the PATH, it will become a string and we need to re-convert it to a list
        $env.PATH = do (env-conversions).path.from_string $env.PATH
      }]

      alias switch = sudo nixos-rebuild switch --flake /home/lobo/nix
      alias boot = sudo nixos-rebuild boot --flake /home/lobo/nix
      alias v = nvim
      alias ll = ls -l
      alias cat = bat
      alias ga = git add -A
      alias gs = git status
      alias gd = git diff
      alias gc = git commit
      alias gcm = git commit -m
      alias gp = git push
      alias gl = git log
      alias gwta = git worktree add
      alias gwtr = git worktree remove
      alias cpv = rsync --info=progress2 --no-inc-recursive -ahP
      alias toclip = wl-copy
      alias fromclip = wl-paste
      alias tm = ssh oddity@training-megaset
      alias t1 = ssh oddity@training-1
      alias t2 = ssh oddity@training-2
      alias t3 = ssh oddity@training-3
      alias t4 = ssh oddity@training-4
    '';
  };
}
