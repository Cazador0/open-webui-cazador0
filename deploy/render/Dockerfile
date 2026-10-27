# Thin wrapper over the official image: turns OLLAMA_API_KEY into the
# OLLAMA_API_CONFIGS JSON Open WebUI expects, then runs the stock start script.
FROM ghcr.io/open-webui/open-webui:main

COPY entrypoint.sh /app/backend/render-entrypoint.sh

CMD ["bash", "render-entrypoint.sh"]
