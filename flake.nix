{
  nixConfig = {
    extra-substituters = ["https://noctalia.cachix.org"];
    extra-trusted-public-keys = ["noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
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
            nixpkgs.overlays = [llm-agents.overlays.default];
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
