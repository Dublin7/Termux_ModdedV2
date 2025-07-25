#!/data/data/com.termux/files/usr/bin/bash

clear
echo "🌌 Welcome back to the DevVaults Terminal Sanctuary"
termux-tts-speak "Vault unlocked."

python decrypt_config.py
python whisper_log.py "🚪 Vault access @ $(date)"
