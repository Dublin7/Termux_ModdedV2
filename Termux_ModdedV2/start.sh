#!/data/data/com.termux/files/usr/bin/bash

# Load environment
clear
echo "🔐 Initializing DevVault..."
CONFIG="config.json"
ENC_CONFIG="config.json.enc"
SALT_FILE="salt.bin"

# Auto-decrypt if needed
if [[ -f "$ENC_CONFIG" && ! -f "$CONFIG" ]]; then
    echo "🔓 Decrypting vault config..."
    python3 scripts/decrypt_config.py "$ENC_CONFIG" "$SALT_FILE" "$CONFIG"
    echo "✅ Config ready."
fi

while true; do
clear
echo -e "🌐 Welcome to \e[1mDevVaults Pro Terminal\e[0m"
echo "Choose an option:"
echo "1) 🧠 Mistr Mintr (Memory Logger)"
echo "2) 📜 View Memory Log"
echo "3) 🗓️ Daily Log"
echo "4) 💱 Check Crypto Prices"
echo "5) 📝 Open Scratchpad"
echo "6) 🎭 Mood Tracker"
echo "7) 💸 Welfare Drop Check (Thursdays)"
echo "8) 🔐 Encrypt Config"
echo "9) 🔓 Decrypt Config"
echo "10) 🚀 GitHub Sync (Auto)"
echo "11) 📦 Push memolog.txt"
echo "12) 🔁 Auto Re-encrypt + Clean Config"
echo "x) Exit"
read -p "> " choice

case $choice in
  1) python3 scripts/mistr_mintr.py ;;
  2) cat memory_log.txt | less ;;
  3) nano memory_log.txt ;;
  4) python3 scripts/crypto_prices.py ;;
  5) nano scratchpad.txt ;;
  6) python3 scripts/mood_tracker.py ;;
  7) python3 scripts/welfare_check.py ;;
  8) python3 scripts/encrypt_config.py "$CONFIG" "$ENC_CONFIG" "$SALT_FILE" ;;
  9) python3 scripts/decrypt_config.py "$ENC_CONFIG" "$SALT_FILE" "$CONFIG" ;;
  10) bash github_menu.sh ;;
  11) python3 github_sync.py --push-memolog ;;
  12) 
      python3 scripts/encrypt_config.py "$CONFIG" "$ENC_CONFIG" "$SALT_FILE"
      rm -f "$CONFIG"
      echo "🔒 Vault re-secured and config wiped."
      ;;
  x) echo "👋 Goodbye." && break ;;
  *) echo "❌ Invalid option." ;;
esac

read -n 1 -s -r -p "🔁 Press any key to return to menu..."
done
