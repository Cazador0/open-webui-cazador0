# Hosting this fork: Render (backend) + Vercel (front door)

Open WebUI is a long-running FastAPI app with a database, background tasks and
file storage, so it can't run on Vercel's serverless functions. It runs on
Render, and a Vercel project proxies your `*.vercel.app` URL to it. Models come
from Ollama Cloud.

```
phone ──https──> open-webui-cazador0.vercel.app ──rewrite──> open-webui-cazador0.onrender.com ──> ollama.com
                  (deploy/vercel)                             (render.yaml, persistent disk)       (OLLAMA_API_KEY)
```

## 1. Backend on Render

1. Open https://render.com/deploy?repo=https://github.com/cazador0/open-webui-cazador0
   (sign in with GitHub and allow access to this repo).
2. Fill in the prompted secrets:
   - `OLLAMA_API_KEY`: your key from https://ollama.com/settings/keys
   - `WEBUI_ADMIN_EMAIL` / `WEBUI_ADMIN_PASSWORD`: your admin login (created on first boot)
   - `WEBUI_URL`: `https://open-webui-cazador0.vercel.app` (or your Vercel domain)
3. Click **Apply**. The first boot takes a few minutes. Note the service URL;
   if it isn't `https://open-webui-cazador0.onrender.com`, update the
   destination in `deploy/vercel/vercel.json`.

The Ollama key lives on Render because the backend is what calls Ollama;
the Vercel proxy never sees it.

## 2. Front door on Vercel

1. Open https://vercel.com/new and import `cazador0/open-webui-cazador0`.
2. Set **Root Directory** to `deploy/vercel` and **Framework Preset** to *Other*.
3. Deploy. No environment variables are needed.

## Notes

- Signup is disabled; only the admin from step 1 can log in and invite users.
- `ENABLE_WEBSOCKET_SUPPORT=false` because Vercel rewrites can't proxy
  WebSockets. Live updates use HTTP long-polling instead.
- Chats, settings and uploads live on the Render disk at `/app/backend/data`.
- Settings such as the Ollama connection are saved to the database on first
  boot. Later changes to those env vars are ignored; edit them in
  **Admin Settings → Connections** instead.
- Render redeploys on every push to the branch it tracks, and each deploy pulls
  the latest `ghcr.io/open-webui/open-webui:main` image.
