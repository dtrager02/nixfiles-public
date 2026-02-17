#!/usr/bin/env bash

# Script to update vscode.nix with currently installed VS Code extensions

set -e

SCRIPT_DIR="$(dirname "$0")"
VSCODE_NIX="$SCRIPT_DIR/../vscode.nix"

# Get extension metadata from sync-vscode-extensions.sh (outputs Nix format)
EXTENSIONS_DATA=$("$SCRIPT_DIR/sync-vscode-extensions.sh")

# Extract and reformat each extension block
EXTENSION_LIST=$(echo "$EXTENSIONS_DATA" | sed -n '/^  {$/,/^  }$/p' | \
  awk 'BEGIN { ext="" }
       /^  {$/ { ext="      (pkgs.vscode-utils.buildVscodeMarketplaceExtension {\n        mktplcRef = {" }
       /name =/ { gsub(/;$/, ";"); ext=ext"\n          "$0 }
       /publisher =/ { gsub(/;$/, ";"); ext=ext"\n          "$0 }
       /version =/ { gsub(/;$/, ";"); ext=ext"\n          "$0 }
       /sha256 =/ { gsub(/;$/, ";"); ext=ext"\n          "$0 }
       /^  }$/ { ext=ext"\n        };\n      })"; print ext; ext="" }')

# Create a temp file with the updated vscode.nix
TEMP_FILE=$(mktemp)

# Read vscode.nix and replace extensions section
awk -v ext_list="$EXTENSION_LIST" '
  /extensions = \[/ {
    print $0
    print ext_list
    in_ext=1
    next
  }
  in_ext && /^    \];/ {
    print $0
    in_ext=0
    next
  }
  !in_ext { print }
' "$VSCODE_NIX" > "$TEMP_FILE"

mv "$TEMP_FILE" "$VSCODE_NIX"

echo "✓ Updated extensions in vscode.nix"
