#!/data/data/com.termux/files/usr/bin/bash
clear
echo "🌐 DevsVaultsPro Terminal Menu:"
echo "a) Start Mistr Mintr (Memory Logger)"
echo "b) View Memory Log"
echo "c) Daily Log"
echo "d) Check Crypto Prices"
echo "e) Open Scratchpad"
echo "f) Mood Tracker"
echo "g) Welfare Drop Check (Thursdays)"
echo "1) Eidolon Notes (Encrypted Thoughts)"
echo "2) Memory Stone (Spiritual Quote TTS)"
echo "3) Audio EVP Recorder"
echo "4) BeatBuddy – Techno Beat Oracle"
echo "5) Whisper Input (Voice Command)"
echo "6) TTS Prophet – Read Last Thought"
echo "x) Exit"
read -p "> " choice

case "$choice" in
  a) bash scripts/mistr_mintr.sh ;;
  b) cat memory_log.txt ;;
  c) date >> daily_log.txt && echo 'Log started.' ;;
  d) bash scripts/crypto_hub.sh ;;
  e) nano scratchpad.txt ;;
  f) echo "$(date) Mood: " >> mood_log.txt && read mood && echo "$mood" >> mood_log.txt ;;
  g) bash scripts/welfare_alert.sh ;;
  1) bash scripts/eidolon_notes.sh ;;
  2) bash scripts/memory_stone.sh ;;
  3) bash scripts/recorder_mode.sh ;;
  4) bash scripts/beatbuddy.sh ;;
  5) termux-speech-to-text ;;
  6) tail -n 1 memory_log.txt | termux-tts-speak ;;
  
  # 🕳️ Hidden Triggers
  devmode1337)
    echo "🛠️ Dev Mode Unlocked..."
    ls -la scripts/
    ;;
  ghost@termux)
    echo "👻 You are now Ghost@Termux..."
    echo "identity=ghost" > .termux_identity
    ;;
  mystify)
    for i in {1..3}; do
      q=$(shuf -n 1 quotes.txt)
      echo "🌀 $q"
      termux-tts-speak "$q"
      sleep 1
    done
    ;;
  junkiecheck)
    echo "💸 Did you get your welfare?"
    read reply
    if [[ "$reply" == "yes" ]]; then
      echo -e "\e[1;35m🎉 Hahaha koji si ti welfare Junkie 😂\e[0m"
      termux-tts-speak "Hahaha koji si ti welfare Junkie"
    fi
    ;;
  playback@last)
    latest=$(ls -t recordings/ | head -n 1)
    termux-media-player play "recordings/$latest"
    ;;

  *) echo "Invalid option. Try again." ;;
esac
