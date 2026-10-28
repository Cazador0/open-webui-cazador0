#!/usr/bin/env bash
set -euo pipefail

# Build the per-connection config with python so any key characters are JSON-escaped.
if [ -n "${OLLAMA_API_KEY:-}" ] && [ -z "${OLLAMA_API_CONFIGS:-}" ]; then
  OLLAMA_API_CONFIGS="$(python3 -c 'import json, os; print(json.dumps({"0": {"enable": True, "key": os.environ["OLLAMA_API_KEY"]}}))')"
  export OLLAMA_API_CONFIGS
fi

exec bash start.sh
