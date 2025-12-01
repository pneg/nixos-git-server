{
  description = "Converts JSON into a flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };
  outputs = { self, nixpkgs }:
    (let serverConfig = nixpkgs.lib.trivial.importJSON ./config.json; in
      serverConfig // {
        gitoliteAdminPubkeyFileAbsPath =
          builtins.toString ./. + "/" + serverConfig.gitoliteAdminPubkeyFileRelPath;
      }
    );
}
