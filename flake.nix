{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/32d7d366313675be94ab24e32860fa4dc1c742b4";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/32d7d366313675be94ab24e32860fa4dc1c742b4";
    home-manager = {
      url = "github:nix-community/home-manager/7664e05e2413d5e2b8c54a884eb8ea0f8a504fc2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/b2009681f7ecee2cc9c9a71a7b47f923a3b78e04";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix/036c78ea4cd8a42c8546c6316a944fd7d59d4341";
    nix-ld = {
      url = "github:Mic92/nix-ld/b320f5cb8b7f141c224c3631539cd0c45fcf7ee3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix/6b2e2cb6d784cc919c64f998093ecdb4f2b76152";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-ld,
    llm-agents,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    globals = import ./globals.nix;
    localOverlay = import ./pkgs/overlay.nix;
    mkPkgs = system:
      import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          llm-agents.overlays.default
          localOverlay
        ];
      };
    mkSystem = globalsKey: let
      hostGlobals = globals.${globalsKey};
      specialArgs = {
        # these variables will be available to all modules
        globals = hostGlobals;
        hostName = globalsKey;
      };
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          {
            nixpkgs.overlays = [
              llm-agents.overlays.default
              localOverlay
            ];
          }
          ./system
          inputs.catppuccin.nixosModules.catppuccin
          nix-ld.nixosModules.nix-ld
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = false;
            home-manager.backupFileExtension = "bak";
            home-manager.users.${hostGlobals.username} = {
              imports = [
                ./home
                inputs.noctalia.homeModules.default
                inputs.catppuccin.homeModules.catppuccin
              ];
            };
            home-manager.extraSpecialArgs = specialArgs;
          }
        ];
      };
  in {
    nixosConfigurations = nixpkgs.lib.genAttrs (builtins.attrNames globals) mkSystem;
    overlays.default = localOverlay;
    packages.${system} = let
      pkgs = mkPkgs system;
    in {
      inherit (pkgs) videoduplicatefinder-cli;
      default = pkgs.videoduplicatefinder-cli;
    };
  };
}
