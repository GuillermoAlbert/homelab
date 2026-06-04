# CT 106 — athletix-dev

**OS:** Debian 12
**Resources:** 2 vCPU, 2048 MB RAM, 192.168.18.198
**Tailscale IP:** `100.109.199.70`

## Services

| Service | Port | Access |
|---------|------|--------|
| PostgreSQL 16 (Docker) | 5432 | LAN + Tailscale |

## Setup

Single Docker Compose service. A read-only role (`POSTGRES_RO_USER`) is provisioned automatically on first boot via an init script in `docker-entrypoint-initdb.d`.

```
/opt/athletix/
├── docker-compose.yml
├── .env                          # DB credentials
└── docker/postgres/init/         # Init SQL scripts (ro role setup)
```

## Provisioning notes

1. Create Debian LXC with `nesting=1`
2. Install Docker
3. Clone Athletix project
4. Copy `.env` with credentials
5. `docker compose up -d`
