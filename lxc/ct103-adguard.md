# CT 103 — adguard

**OS:** Debian 12
**Resources:** 2 vCPU, 512 MB RAM, 192.168.18.149
**Tailscale IP:** `100.95.206.109`

## Services

| Service | Port | Access |
|---------|------|--------|
| DNS resolver | 53 (UDP/TCP) | Tailscale (entire tailnet) |
| AdGuard Home Web UI | 80 | LAN + Tailscale |

## Setup

AdGuard Home is installed as a native binary (not Docker) and runs as a systemd service (`AdGuardHome.service`).

```
/opt/AdGuardHome/
├── AdGuardHome          # Binary
├── AdGuardHome.yaml     # Main config (blocklists, upstream DNS, clients)
└── data/                # Query log, statistics DB
```

## Key config

- **Upstream DNS:** Cloudflare DoH (`https://dns.cloudflare.com/dns-query`)
- **Bootstrap DNS:** `1.1.1.1`, `8.8.8.8`
- **Blocklists:** Standard AdGuard + OISD + regional lists

## Provisioning notes

1. Create Debian LXC
2. Download AdGuard Home binary: `curl -s -S -L https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/master/scripts/install.sh | sh -s -- -v`
3. Access initial setup at `:3000`, then configure via web UI
4. Point all Tailscale clients' DNS to `100.95.206.109` via Tailscale admin console

## Backup config

```bash
# Export current config
pct exec 103 -- cat /opt/AdGuardHome/AdGuardHome.yaml > adguard-backup.yaml
```
