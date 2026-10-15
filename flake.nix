{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/27245c44440698c31d5b3ff0806e59c92ff30e3e";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/27245c44440698c31d5b3ff0806e59c92ff30e3e";
    home-manager = {
      url = "github:nix-community/home-manager/7b4c5ec4bedaf1e062bbc1bcaeddbc6bd242aa1b";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/0433e3f8517ffc615906f6a17ac824724353aefb";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-community-plugins = {
      url = "github:noctalia-dev/community-plugins/f8a29282af82c6f385df98621740245e11c6900e";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix/89b3eacf59d6b5eefbc2d69c3a4eb5aaf66d63bc";
    nix-ld = {
      url = "github:Mic92/nix-ld/374abbdb640db0e965496ff38d045a871d3c2d57";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix/2a6f134521edbf22992d89fdf97d417fb81c5334";
    };
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
    niri-float-sticky = {
      url = "github:probeldev/niri-float-sticky/b3e79bd99bf99b993c3348f0051564f9d25f65e4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-ld,
    llm-agents,
    ...
  } @ inputs: let
    globals = import ./globals.nix;
    mkSystem = globalsKey: let
      hostGlobals = globals.${globalsKey};
      specialArgs = {
        # these variables will be available to all modules
        inherit inputs;
        globals = hostGlobals;
        hostName = globalsKey;
      };
    in
      nixpkgs.lib.nixosSystem {
        specialArgs = specialArgs;
        modules = [
          {
            nixpkgs.overlays = [
              llm-agents.overlays.shared-nixpkgs
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
  };
}
