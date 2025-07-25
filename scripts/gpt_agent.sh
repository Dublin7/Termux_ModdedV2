#!/data/data/com.termux/files/usr/bin/bash

# === Config ===
API_KEY=$(grep OPENAI_API_KEY .env | cut -d '=' -f2)
MODEL="gpt-4"  # or gpt-3.5-turbo
SYSTEM_PROMPT="You are a helpful assistant running inside Termux."

# === Functions ===
ask_openai() {
  local user_prompt="$1"

  curl -s https://api.openai.com/v1/chat/completions \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "{
      \"model\": \"$MODEL\",
      \"messages\": [
        {\"role\": \"system\", \"content\": \"$SYSTEM_PROMPT\"},
        {\"role\": \"user\", \"content\": \"$user_prompt\"}
      ],
      \"temperature\": 0.7
    }" | jq -r '.choices[0].message.content'
}

# === Main ===
if [ -z "$1" ]; then
  echo "🧠 Enter prompt:"
  read -r input
else
  input="$*"
fi

ask_openai "$input"
