{
  description = "Livefish NixOS configuration!!11!";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    sddm-stray.url = "github:Bqrry4/sddm-stray";
  };

  outputs = { self, nixpkgs, home-manager, agenix, ... }@inputs: {
    nixosConfigurations.livefish-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix

        # make home-manager as a module of nixos
        # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
	        home-manager.users.livefish = import ./home.nix;
	      }	

        agenix.nixosModules.default
      ];
    };
  };
}
