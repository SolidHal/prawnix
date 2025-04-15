{
  description = "prawnix";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

    solidnix.url = "github:SolidHal/nixos-dotfiles";

    # use precreated nix-index databases for shell command not found
    #TODO as-is, this installs the database but doesn't update the command-not-found.sh
    # so we still have to run nix-locate manually
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { self, nixpkgs, nix-index-database, solidnix, ... }@inputs: {
    nixosConfigurations.prawnix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      # this lets us import modules from flakes in our other modules
      specialArgs = {
        user = "prawn";
        inputs = inputs;
      };
      modules = [
        nix-index-database.nixosModules.nix-index
        ./configuration.nix
      ];
    };
  };
}
