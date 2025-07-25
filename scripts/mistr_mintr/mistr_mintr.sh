#!/data/data/com.termux/files/usr/bin/bash

MODEL_PATH="$HOME/DevVaults/ModdedV3/scripts/Termux_ModdedV2/DevsVaultsPro/llama.cpp/models/mistral-7b-instruct-v0.1.Q4_0.gguf"
MAIN_BIN="$HOME/DevVaults/ModdedV3/scripts/Termux_ModdedV2/DevsVaultsPro/llama.cpp/main"
LOG_PATH="$HOME/mistr_mintr/memory.log"

echo "🤖 Mistr Mintr is online. Type 'exit' to leave."

while true; do
    echo -n "You: "
    read input

    if [[ "$input" == "exit" ]]; then
        echo "👋 Exiting Mistr Mintr. Session saved."
        break
    fi

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    echo "[$timestamp] You: $input" >> "$LOG_PATH"

    output=$("$MAIN_BIN" -m "$MODEL_PATH" -p "$input" -n 256 -t 4 -c 1024 --temp 0.7)

    response=$(echo "$output" | sed '1,/assistant/d')
    echo "Mistr Mintr: $response"
    echo "[$timestamp] Mistr Mintr: $response" >> "$LOG_PATH"
done
