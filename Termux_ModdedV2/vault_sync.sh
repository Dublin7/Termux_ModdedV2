#!/data/data/com.termux/files/usr/bin/bash

echo "🔐 Decrypting vault..."
python decrypt_config.py

echo "🔁 Git Add, Commit, Push"
git add .
git commit -m "🔒 Vault Sync @ $(date '+%Y-%m-%d %H:%M:%S')"
git push

echo "♻️ Re-encrypting vault..."
python encrypt_config.py

echo "🧹 Cleaning up raw config..."
[ -f config.json ] && rm config.json

echo "✅ Vault sync complete."
termux-tts-speak "Vault sync complete"
