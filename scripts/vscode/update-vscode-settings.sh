#!/usr/bin/env bash

# Script to update vscode.nix with current VS Code user settings
# Note: Only simple settings are synced (strings, numbers, booleans)
# Complex nested objects are skipped

set -e

SCRIPT_DIR="$(dirname "$0")"
VSCODE_NIX="$SCRIPT_DIR/../vscode.nix"
VSCODE_SETTINGS="$HOME/.config/Code/User/settings.json"

# Extract only top-level simple key-value pairs from settings.json
# Match lines with exactly 4 spaces of indentation (top level in the JSON)
SETTINGS_NIX=$(grep -E '^    "[^"]+"\s*:\s*(true|false|null|[0-9]+|"[^"]*")\s*,?\s*$' "$VSCODE_SETTINGS" | \
  sed 's/,\s*$//' | \
  awk -F': ' '{
    # Extract key (remove quotes and whitespace)
    gsub(/^[[:space:]]*"|"[[:space:]]*$/, "", $1)
    key = $1
    
    # Extract value (trim whitespace)
    value = $2
    gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
    
    # Escape quotes in string values
    if (value ~ /^"/) {
      gsub(/\\/, "\\\\", value)
    }
    
    print "      \"" key "\" = " value ";"
  }')

# Create a temp file with the updated vscode.nix
TEMP_FILE=$(mktemp)

# Read vscode.nix and replace userSettings section
awk -v settings="$SETTINGS_NIX" '
  /userSettings = \{/ {
    print $0
    print settings
    in_settings=1
    next
  }
  in_settings && /^    \};/ {
    print $0
    in_settings=0
    next
  }
  !in_settings { print }
' "$VSCODE_NIX" > "$TEMP_FILE"

mv "$TEMP_FILE" "$VSCODE_NIX"

echo "✓ Updated userSettings in vscode.nix"
