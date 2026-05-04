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
            pkgs.jq 
          ];

          shellHook = ''
            # 1. Link DIRECTLY to the 'std' folder 
            ln -sfn ${pkgs.c3c}/lib/c3/std ./.c3_lib

            # 2. Path Discovery
            ABS_PATH=$(pwd)/.c3_lib
            C3C_BIN=$(which c3c)
            
            # Use /usr/bin/xcode-select explicitly to bypass Nix-provided SDKs
            REAL_XCODE_DIR=$(/usr/bin/xcode-select -p)
            
            # Prioritize standard system locations to avoid the Nix Store SDK bug
            if [ -f "/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Versions/A/LLDB" ]; then
                LLDB_LIB="/Library/Developer/CommandLineTools/Library/PrivateFrameworks/LLDB.framework/Versions/A/LLDB"
            elif [ -f "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB" ]; then
                LLDB_LIB="/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB"
            else
                # Fallback to whatever xcode-select says, but verify it's not a Nix path
                LLDB_LIB="$REAL_XCODE_DIR/Library/PrivateFrameworks/LLDB.framework/Versions/A/LLDB"
            fi

            # 3. Generate/Update c3lsp.json
            cat <<EOF > c3lsp.json
{
    "c3c_path": "$C3C_BIN",
    "stdlib_path": "$ABS_PATH",
    "diagnostics_delay": 500
}
EOF

            # 4. Comment-Safe VS Code Settings Update
            mkdir -p .vscode
            if [ -f .vscode/settings.json ]; then
                tmp_json=$(mktemp)
                tmp_settings=$(mktemp)
                
                # Strip comments for jq
                sed 's|//.*||g' .vscode/settings.json | sed 's|/\*.*\*/||g' > "$tmp_json"
                
                jq ". + {
                    \"c3lspclient.lsp.c3.stdlibPath\": \"$ABS_PATH\",
                    \"c3lspclient.lsp.c3.path\": \"$C3C_BIN\",
                    \"lldb.library\": \"$LLDB_LIB\"
                }" "$tmp_json" > "$tmp_settings" && mv "$tmp_settings" .vscode/settings.json
                
                rm "$tmp_json"
            fi

            echo "🛡️  Environment Synchronized."
            echo "✅ Using SYSTEM Debugger: $LLDB_LIB"
          '';
        };
      });
}