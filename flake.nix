{
  description = "Dev shell for template-pure-javascript";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    let
      systems = [ "aarch64-darwin" "x86_64-darwin" "x86_64-linux" "aarch64-linux" ];
      forEachSystem = f: builtins.listToAttrs (map (system: { name = system; value = f system; }) systems);
    in
    {
      devShells = forEachSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };

          chosenNode = pkgs.nodejs_24;
          chosenPnpm = pkgs.pnpm.override { nodejs = chosenNode; };
        in
        {
          # Shell for local + CI builds, used by universal-build
          default = pkgs.mkShell {
            packages = [
              chosenNode
              chosenPnpm
            ];
          };

          # Shell for runtime-only environment.
          # The Dockerfile snapshots this environment via `nix print-dev-env` and applies it at container startup.
          runtime = pkgs.mkShell {
            packages = [
              chosenNode
            ];
          };
        });
    };
}
