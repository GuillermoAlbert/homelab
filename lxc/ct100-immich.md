# CT 100 — cerebro.docker

**OS:** Debian 12 (unprivileged)
**Resources:** 4 vCPU, 4096 MB RAM, 2048 MB swap, 30 GB rootfs
**LAN IP:** `192.168.18.170`
**Tailscale IP:** `100.86.107.24`

## Features

- `nesting=1`, `keyctl=1`, `fuse=1` (required for Docker in LXC)
- Intel iGPU passthrough: `/dev/dri/renderD128` (gid=992), `/dev/dri/card0` (gid=44)
- NAS bind mount: `/mnt/pve/almacenamiento/datos` → `/datos` inside CT
- `protection: 1` set in PVE to prevent accidental deletion
- Provisioned via [community-scripts/ProxmoxVE](https://github.com/community-scripts/ProxmoxVE) Docker LXC script

## Services

| Service | Port | Access |
|---------|------|--------|
| Immich web + API | 2283 | Tailscale only (`100.86.107.24:2283`) |
| PostgreSQL 14 (internal) | 5432 | Docker internal only |
| Valkey/Redis (internal) | 6379 | Docker internal only |

## Key paths

```
/opt/immich/
├── docker-compose.yml
├── hwaccel.transcoding.yml   # Intel QuickSync config
├── hwaccel.ml.yml            # OpenVINO config
└── .env                      # DB credentials, upload path
/datos/                       # NAS mount — photo library
```

## Provisioning notes

1. Deploy Docker LXC from community-scripts on PVE host
2. Pass through iGPU devices in PVE config (`dev0`, `dev1`)
3. Add NAS bind mount (`mp0`)
4. Inside CT: follow [Immich Docker Compose install](https://docs.immich.app/install/docker-compose)
5. Set `UPLOAD_LOCATION=/datos` in `.env`
6. Start: `docker compose up -d`

## Cron / maintenance

No local cron — Immich has built-in background jobs (thumbnail generation, ML tagging, etc.) managed internally.
