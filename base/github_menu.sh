#!/data/data/com.termux/files/usr/bin/bash

echo "🔹 DevsVault GitHub Menu"
echo "1) List Repos"
echo "2) Push memolog.txt to GitHub"
echo "3) Exit"
read -p "Choose: " opt

case "$opt" in
  1)
    gh repo list
    ;;
  2)
    python3 github_sync.py
    ;;
  3)
    exit
    ;;
  *)
    echo "Invalid option."
    ;;
esac
