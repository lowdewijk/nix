{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/59dacfab0717b157eb8f758eb1c16f74805ec90e";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/59dacfab0717b157eb8f758eb1c16f74805ec90e";
    home-manager = {
      url = "github:nix-community/home-manager/42bb40f7aaab63a107b64a20c4a4ade6550758d0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell/cf55ac0d9ea1edeeb12b90bc51f2808ea5797af6";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-community-plugins = {
      url = "github:noctalia-dev/community-plugins";
      flake = false;
    };
    catppuccin.url = "github:catppuccin/nix/673f730d0fc8db3468c51575f1d3d777cc55e51f";
    nix-ld = {
      url = "github:Mic92/nix-ld/1267405dbb13b1b664445ff3654da3a33ee272e4";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix/d4a6e87fd4b9d7f551b0d2aba1514213617502a5";
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
