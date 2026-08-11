{
  config,
  lib,
  pkgs,
  globals,
  ...
}: let
  nuScriptsSource = "${globals.nixos_git_root}/home/nushell/scripts";

  createNuScript = {
    name,
    source ? "${nuScriptsSource}/${name}.nu",
    runtimeInputs ? [],
  }: let
    installedScript = "${config.xdg.configHome}/nushell/scripts/${name}.nu";
  in {
    xdg.configFile."nushell/scripts/${name}.nu".source =
      config.lib.file.mkOutOfStoreSymlink source;

    home.packages = [
      (pkgs.writeShellApplication {
        inherit name;

        runtimeInputs =
          [
            pkgs.nushell
          ]
          ++ runtimeInputs;

        text = ''
          exec nu ${lib.escapeShellArg installedScript} "$@"
        '';
      })
    ];
  };
in
  lib.mkMerge [
    {
      programs.nushell.enable = true;
    }

    (createNuScript {
      name = "ml2-create-worktree";

      runtimeInputs = [
        pkgs.git
      ];
    })

    {
      programs.nushell = {
        enable = true;

        settings = {
          edit_mode = "vi";
          show_banner = false;
        };

        shellAliases = {
          switch = "sudo nixos-rebuild switch --flake /home/lobo/nix";
          boot = "sudo nixos-rebuild boot --flake /home/lobo/nix";
          v = "nvim";
          l = "ls";
          ll = "ls -l";
          cat = "bat";
          ga = "git add -A";
          gs = "git status";
          gd = "git diff";
          gc = "git commit";
          gcm = "git commit -m";
          gp = "git push";
          gwta = "git worktree add";
          gwtr = "git worktree remove";
          cpv = "rsync --info=progress2 --no-inc-recursive -ahP";
          toclip = "wl-copy";
          fromclip = "wl-paste";
          t3 = "ssh -t oddity@training-3 \"tmux -L lodewijk -f ~/lodewijk/.tmux.conf new-session -A -s main 'exec nu -l'\"";
          t4 = "ssh -t oddity@training-4 \"tmux -L lodewijk -f ~/lodewijk/.tmux.conf new-session -A -s main 'exec nu -l'\"";
        };

        extraConfig = ''
          use std/config *

          def --wrapped gl [...args] {
            ^git log "--pretty=format:%h%x1f%aI%x1f%an%x1f%s" ...$args
            | lines
            | split column (char unit_separator) sha date author message
            | update date { into datetime }
          }

          $env.PROMPT_INDICATOR_VI_INSERT = ""
          $env.PROMPT_INDICATOR_VI_NORMAL = ""

          # Setup Direnv hook
          # Initialize the PWD hook as an empty list if it doesn't exist.
          $env.config.hooks.env_change.PWD = $env.config.hooks.env_change.PWD? | default []

          # Don't list row numbers in table mode
          $env.config.table.index_mode = "never"

          $env.config.hooks.env_change.PWD ++= [{||
            if (which direnv | is-empty) {
              return
            }

            direnv export json | from json | default {} | load-env
            $env.PATH = do (env-conversions).path.from_string $env.PATH
          }]

          # Setup
          $env.config.menus ++= [{
            name: completion_menu
            only_buffer_difference: false
            marker: "| "
            type: {
              layout: ide
              columns: 1
              col_width: 50
              selection_rows: 45
              description_rows: 36
            }
            style: {}
          }]

        '';
      };
    }
  ]
