{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-ld, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs;
      };
      modules = [
        ./system
        inputs.catppuccin.nixosModules.catppuccin
        nix-ld.nixosModules.nix-ld
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lobo = {
	    imports = [
	      ./home
	      inputs.catppuccin.homeManagerModules.catppuccin
            ];
          };
	  home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
  };
}
