#!/usr/bin/env bash
set -e

KEY_URL="https://raw.githubusercontent.com/M1ha1V2/.keys/refs/heads/main/beleaua.pub"

# Read user from TTY (curl | bash safe)
read -rp "Install SSH key for user [root]: " TARGET_USER </dev/tty || true
TARGET_USER=${TARGET_USER:-root}

# Resolve home directory
HOME_DIR=$(getent passwd "$TARGET_USER" | cut -d: -f6)

if [[ -z "$HOME_DIR" ]]; then
  echo "❌ User '$TARGET_USER' does not exist"
  exit 1
fi

SSH_DIR="$HOME_DIR/.ssh"
AUTH_KEYS="$SSH_DIR/authorized_keys"

echo "📁 Using home directory: $HOME_DIR"

mkdir -p "$SSH_DIR"
touch "$AUTH_KEYS"

TMP_KEY=$(mktemp)
curl -fsSL "$KEY_URL" -o "$TMP_KEY"

if grep -qxF "$(cat "$TMP_KEY")" "$AUTH_KEYS"; then
  echo "ℹ️ SSH key already present, skipping"
else
  echo "🔑 Adding SSH key"
  cat "$TMP_KEY" >> "$AUTH_KEYS"
fi

rm -f "$TMP_KEY"

chmod 700 "$SSH_DIR"
chmod 600 "$AUTH_KEYS"
chown -R "$TARGET_USER:$TARGET_USER" "$SSH_DIR"

echo "✅ SSH key installed for user '$TARGET_USER'"
