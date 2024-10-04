{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    git-repo-sync = {
      url = "github:oddity-ai/git-repo-sync/nixify";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-ld,
    plasma-manager,
    git-repo-sync,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    globals = import ./globals.nix;
    specialArgs = {
      # these variables will be available to all modules
      git-repo-sync = git-repo-sync.packages.${system}.default;
      inherit globals;
    };
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      specialArgs = specialArgs;
      modules = [
        ./system
        inputs.catppuccin.nixosModules.catppuccin
        nix-ld.nixosModules.nix-ld
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.${globals.username} = {
            imports = [
              ./home
              inputs.catppuccin.homeManagerModules.catppuccin
              plasma-manager.homeManagerModules.plasma-manager
            ];
          };
          home-manager.extraSpecialArgs = specialArgs;
        }
      ];
    };
  };
}
