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
echo "1) Eidolon Notes"
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
  d) bash scripts/crypto_check.sh ;;
  e) nano scratchpad.txt ;;
  f) echo 'How are you feeling today?' >> mood_log.txt ;;
  g) bash scripts/welfare_alert.sh ;;
  1) nano notes/eidolon_note.txt ;;
  2) bash scripts/tts_speak.sh "$(shuf -n 1 quotes.txt)" ;;
  3) bash scripts/evp_record.sh ;;
  4) bash scripts/beatbuddy.sh ;;
  5) bash scripts/voice_input.sh ;;
  6) tail -n 1 memory_log.txt | bash scripts/tts_speak.sh "$(cat)" ;;
  x) exit ;;
  *) echo "Invalid option" ;;
esac
