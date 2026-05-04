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
            pkgs.lldb
            pkgs.jq 
          ];

          shellHook = ''
            # 1. Link DIRECTLY to the 'std' folder 
            # This bypasses the LSP bug where it fails to resolve the 'std/' prefix
            ln -sfn ${pkgs.c3c}/lib/c3/std ./.c3_lib

            ABS_PATH=$(pwd)/.c3_lib
            C3C_BIN=$(which c3c)

            # 2. Update c3lsp.json with absolute paths (No trailing slashes!)
            cat <<EOF > c3lsp.json
{
    "c3c_path": "$C3C_BIN",
    "stdlib_path": "$ABS_PATH",
    "diagnostics_delay": 500
}
EOF

            # 3. Comment-Safe VS Code Settings Update
            mkdir -p .vscode
            if [ -f .vscode/settings.json ]; then
                # Strip comments with sed so jq doesn't choke
                tmp_json=$(mktemp)
                tmp_settings=$(mktemp)
                
                # Remove // and /* */ style comments
                sed 's|//.*||g' .vscode/settings.json | sed 's|/\*.*\*/||g' > "$tmp_json"
                
                jq ". + {
                    \"c3lspclient.lsp.c3.stdlibPath\": \"$ABS_PATH\",
                    \"c3lspclient.lsp.c3.path\": \"$C3C_BIN\"
                }" "$tmp_json" > "$tmp_settings" && mv "$tmp_settings" .vscode/settings.json
                
                rm "$tmp_json"
            else
                cat <<EOF > .vscode/settings.json
{
    "c3lspclient.lsp.enable": true,
    "c3lspclient.lsp.path": "c3-lsp",
    "c3lspclient.lsp.c3.path": "$C3C_BIN",
    "c3lspclient.lsp.c3.stdlibPath": "$ABS_PATH"
}
EOF
            fi

            echo "🛡️  C3 Dev Shell: Symlinks and VS Code settings synchronized."
            echo "📍 Stdlib mapped to: $ABS_PATH"
          '';
        };
      });
}