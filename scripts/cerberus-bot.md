# Cerberus Bot — Proxmox Telegram monitor

Python bot running on the PVE host (`/root/scripts/cerberus_bot.py`). Monitors container state and allows basic Proxmox management via Telegram.

## Config

```
/root/scripts/
├── cerberus_bot.py    # Main bot
├── cerberus.conf      # TELEGRAM_TOKEN + ALLOWED_CHAT_ID
└── venv/              # Python virtualenv
```

`cerberus.conf` format:
```
TELEGRAM_TOKEN=<REDACTED>
ALLOWED_CHAT_ID=<REDACTED>
```

## Commands

| Command | Description |
|---------|-------------|
| `/status` | List all CTs with status |
| `/cpu` | Current CPU usage |
| `/uptime` | Host uptime |
| `/temp` | CPU temperature |
| `/top` | Top processes by CPU |
| `/startct <vmid>` | Start a CT |
| `/stopct <vmid>` | Stop a CT |
| `/restart <vmid>` | Restart a CT |
| `/logs <vmid>` | Recent CT journal logs |
| `/backup` | Trigger manual restic backup |
| `/alertas` | Show active alerts |
| `/dns` | AdGuard Home status |

## Systemd service (if running as daemon)

```ini
[Unit]
Description=Cerberus Proxmox Telegram Bot
After=network-online.target

[Service]
Type=simple
WorkingDirectory=/root/scripts
ExecStart=/root/scripts/venv/bin/python cerberus_bot.py
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

## Run manually

```bash
cd /root/scripts && venv/bin/python cerberus_bot.py
```
