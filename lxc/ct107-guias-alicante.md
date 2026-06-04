# CT 107 — guiasdealicante-dev

**OS:** Debian 12
**Network:** NAT via vmbr1 — LAN IP `10.0.0.2`, host gateway `10.0.0.1`
**Tailscale IP:** `100.65.234.111`

## Why NAT?

The ISP router rejects DHCP for MAC addresses it doesn't recognize beyond a certain count. This CT connects to `vmbr1`, an internal bridge with no physical ports. The PVE host does MASQUERADE (`iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o vmbr0 -j MASQUERADE`) so the router only sees the host's MAC.

## Services

| Service | Port | Access |
|---------|------|--------|
| Next.js dev server | 3000 | Tailscale |
| Flask ETL admin panel | 8080 | Tailscale |

## Project structure

```
/root/
├── app/                  # Next.js frontend
├── components/           # Shared React components
├── auditoria/            # Audit trail data
├── docker-compose.yml    # (if any auxiliary containers)
└── README.md
```

## Systemd services

```
guias-web.service      # Next.js dev server
etl-admin.service      # Flask ETL admin panel
```

## Provisioning notes

1. Create Debian LXC — assign `net0` to `vmbr1` with static IP `10.0.0.2/24`, GW `10.0.0.1`
2. On PVE host, verify iptables MASQUERADE rule is active:
   ```bash
   iptables -t nat -L POSTROUTING -n -v | grep 10.0.0
   ```
3. Install Node.js, Python 3, Tailscale
4. `tailscale up` — internet access goes through NAT
5. Deploy app and systemd services
