{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = { self, nixpkgs, home-manager,... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
      system = "x86_64-linux";
      specialArgs = { 
        inherit inputs;
      };
      modules = [
        ./system
        inputs.catppuccin.nixosModules.catppuccin
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
