#!/usr/bin/env bash
set -e

KEY_URL="https://raw.githubusercontent.com/NaysKutzu/.keys/refs/heads/main/mythical.pub"

read -rp "Install SSH key for user [root]: " TARGET_USER
TARGET_USER=${TARGET_USER:-root}

# Get home directory safely
HOME_DIR=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [[ -z "$HOME_DIR" ]]; then
  echo "❌ User '$TARGET_USER' does not exist"
  exit 1
fi

SSH_DIR="$HOME_DIR/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

echo "📁 Using home directory: $HOME_DIR"

# Create .ssh if missing
if [[ ! -d "$SSH_DIR" ]]; then
  echo "➕ Creating $SSH_DIR"
  mkdir -p "$SSH_DIR"
fi

# Create authorized_keys if missing
if [[ ! -f "$AUTH_KEYS" ]]; then
  echo "➕ Creating authorized_keys"
  touch "$AUTH_KEYS"
fi

# Download key
TMP_KEY=$(mktemp)
curl -fsSL "$KEY_URL" -o "$TMP_KEY"

# Add key only if not already present
if grep -qxF "$(cat "$TMP_KEY")" "$AUTH_KEYS"; then
  echo "ℹ️ SSH key already present, skipping"
else
  echo "🔑 Adding SSH key"
  cat "$TMP_KEY" >> "$AUTH_KEYS"
fi

rm -f "$TMP_KEY"

# Fix permissions
chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"
chown -R "$TARGET_USER:$TARGET_USER" "$SSH_DIR"

echo "✅ SSH key installed for user '$TARGET_USER'"
