{
  description = "NixOS Git Server with image generator";

  inputs =  {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    # change config file to customize system
    serverConfig.url = "path:config";
  };

  outputs = { self, nixpkgs, serverConfig }@inputs: {
    nixosConfigurations = {
      # configuration for server
      "${serverConfig.hostname}" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
      # configuration for builidng qcow2 images
      image-builder = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
          ./image-builder.nix
        ];
      };
    };
  };
}
