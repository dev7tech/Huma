#!/bin/bash

# Launch Ollama server
ollama serve &

# retry function
retry_until_success() {
  local command="$1"
  local retry_interval=5
  local max_attempts=10
  local attempt=1
  
  until $command; do
    if [ $attempt -ge $max_attempts ]; then
      echo "failure $max_attempts reached."
      exit 1
    fi
    echo "attempt number $attempt failed. retry in $retry_interval seconds..."
    attempt=$((attempt + 1))
    sleep $retry_interval
  done
}

# retry until success
retry_until_success "ollama pull mattw/hornyechidna-13b-v0.1"
retry_until_success "ollama pull llava"
retry_until_success "ollama pull dolphin-llama3"

# execute the backend
python aiConversationManager.py
