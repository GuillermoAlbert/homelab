# CT 104 — factura-processor

**OS:** Debian 12
**Resources:** 2 vCPU, 512 MB RAM, 192.168.18.150
**Tailscale IP:** `100.87.188.5`

## Services

| Service | Port | Access |
|---------|------|--------|
| Factura admin (Flask) | 8080 | Tailscale only |
| nginx (reverse proxy) | 80/443 | internal |
| Postfix | 25 | localhost only |

## Project structure

```
/opt/factura-processor/
├── admin.py              # Flask app bootstrap
├── pipeline.py           # ETL: Gmail → PDF → Gemini → SQLite
├── llm.py                # Gemini Flash (primary) / Pro (fallback)
├── gmail_fetcher.py      # Gmail OAuth2 PDF downloader
├── pdf_to_md.py          # PDF text extraction
├── db.py                 # SQLite layer (WAL mode)
├── config.py             # Reads config.env
├── config.env            # Secrets — NOT in git
└── tests/
/mnt/empresa/             # SQLite DB + PDF storage (NAS or local)
```

## AI model decision

- **Primary:** Gemini Flash (fast + cheap for routine invoices)
- **Fallback:** Gemini Pro (complex/poor-quality PDFs)
- DeepSeek discarded: GDPR concerns (data sent outside EU)
- Local Ollama discarded: hardware insufficient for reliable OCR quality

## Systemd services

```
factura-admin.service    # Flask admin panel
nginx.service            # Reverse proxy
```

## Scheduled jobs (CT cron)

```bash
pct exec 104 -- crontab -l
```

## Backups

PVE `vzdump` snapshot every Sunday at 02:00 → stored on `almacenamiento` (4 copies max).

## Provisioning notes

1. Create Debian LXC
2. `apt install python3 python3-venv nginx postfix`
3. Clone project to `/opt/factura-processor/`
4. `python3 -m venv .venv && .venv/bin/pip install -r requirements.txt`
5. Create `config.env` with Gmail OAuth2 credentials and Gemini API key
6. Set up Gmail OAuth2: run `gmail_fetcher.py` once to authorize
7. Install systemd services
8. Install Tailscale
