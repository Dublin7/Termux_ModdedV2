#!/data/data/com.termux/files/usr/bin/bash

# === CodeMate Max ===
# Voice + Chat + Git + Execution + Memory Logging

PROJECT_DIR="$HOME/devsvaultspro"
MEMORY_LOG="$HOME/mistr_mintr/memory.log"
GIT_ENABLED=true
VOICE_ENABLED=true
CODEMATE_OUT="codemate_out"

mkdir -p $CODEMATE_OUT

speak() {
  termux-tts-speak "$1"
}

log_memory() {
  echo "$(date): $1" >> "$MEMORY_LOG"
}

commit_code() {
  if $GIT_ENABLED; then
    git add .
    git commit -m "🧠 CodeMate Commit: $1"
  fi
}

generate_code() {
  echo "$1" > "$CODEMATE_OUT/latest_input.txt"
  log_memory "$1"
  
  echo "Generating code... (fake for now)"
  echo -e "#!/bin/bash\necho \"Hello World from CodeMate!\"" > "$CODEMATE_OUT/output.sh"
  
  chmod +x "$CODEMATE_OUT/output.sh"
  commit_code "$1"
  
  if $VOICE_ENABLED; then
    speak "Code generated. Executing now."
  fi
  
  bash "$CODEMATE_OUT/output.sh"
}

listen_voice() {
  echo "🎤 Listening (say 'exit' to quit)..."
  termux-speech-to-text > "$CODEMATE_OUT/voice.txt"
  INPUT=$(cat "$CODEMATE_OUT/voice.txt")
  echo "🗣️ $INPUT"
}

run_chat_mode() {
  while true; do
    echo -n "👨‍💻 You: "
    read -r USER_INPUT

    if [[ "$USER_INPUT" == "exit" ]]; then
      echo "👋 Exiting CodeMate."
      speak "Exiting"
      break
    fi

    generate_code "$USER_INPUT"
  done
}

run_voice_mode() {
  while true; do
    listen_voice
    INPUT=$(cat "$CODEMATE_OUT/voice.txt")

    if [[ "$INPUT" == "exit" ]]; then
      echo "👋 Exiting CodeMate."
      speak "Bye bye"
      break
    fi

    generate_code "$INPUT"
  done
}

# === Welcome ===
clear
echo "🧠 Welcome to CodeMate Max (Chat + Voice Mode Enabled)"
speak "Welcome to CodeMate Max. Let's get building."

# === Parallel Mode ===
run_chat_mode &
run_voice_mode &

wait
