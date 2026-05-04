{
  description = "C3 Portable Development Environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.c3c
            pkgs.c3-lsp
            pkgs.lldb  # For debugging
          ];

          shellHook = ''
            # Create a stable symlink to the stdlib in the project root.
            # The LSP will point here instead of the raw /nix/store path.
            ln -sfn ${pkgs.c3c}/lib/c3/std ./.c3_stdlib
            
            # Optional: Add your local build of c3-lsp to the path 
            # if it's sitting in your project root or a bin folder
            export PATH="$PATH:$(pwd)/bin"

            echo "🛡️  C3 Dev Shell Loaded"
            echo "📚 Stdlib symlinked to ./.c3_stdlib"
          '';
        };
      });
}