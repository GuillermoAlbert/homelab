# CT 105 — catapult-etl

**OS:** Debian 12
**Resources:** 2 vCPU, 2048 MB RAM, 512 MB swap, 10 GB disk
**LAN IP:** `192.168.18.151`
**Tailscale IP:** `100.85.30.95`

## Services

| Service | Port | Access |
|---------|------|--------|
| PostgreSQL 16 | 5432 | Tailscale (Power BI) + localhost (ETL) |
| nginx (GPS web + CSV export) | 8080 | Tailscale |
| catapult-admin (Flask) | 8081 | Tailscale |

## Project structure

```
/opt/catapult-etl/
├── config.yaml                 # chmod 600 — API tokens + DB passwords
├── requirements.txt
├── catapult_etl/
│   ├── api.py                  # Catapult Sports API v4 client (httpx + retry)
│   ├── db.py                   # psycopg + upsert
│   ├── transform.py            # API response → SQL dict
│   └── main.py                 # Orchestrator
├── sql/
│   └── 001_init.sql            # Full schema
├── admin.py                    # Flask admin panel
└── web/                        # Coach-facing GPS web UI
```

## Database

- **DB:** `catapult` (PostgreSQL 16)
- **Table:** `gps_sessions` — PK: `(activity_id, equipo, jugador)`
- **View:** `v_gps_sessions` — read-only access for Power BI
- **Users:** `etl_user` (rw), `powerbi_ro` (ro on view)

## Teams tracked

| Config key | Team | Code |
|-----------|------|------|
| `token_ja` | First team | `JA` |
| `token_jb` | Reserve | `JB` |
| `token_jc` | Youth A | `JC` |
| `token_cad` | Cadet A+B | `CA` / `CB` |

## Cron schedule

```
0 6,12,18,23 * * * etl_user /opt/catapult-etl/run.sh
```

## Power BI connection

- Server: `100.85.30.95`
- Port: `5432`
- Database: `catapult`
- User: `powerbi_ro`
- SSL: disabled (Tailscale encrypts traffic)

## Provisioning notes

1. Create Debian LXC
2. `apt install postgresql-16 python3.12 python3.12-venv nginx`
3. Create DB and users, run `sql/001_init.sql`
4. Clone to `/opt/catapult-etl/`, create venv
5. Create `config.yaml` with API tokens (chmod 600)
6. `useradd -r -s /bin/false etl_user`
7. Install cron, logrotate, systemd services
8. Install Tailscale
