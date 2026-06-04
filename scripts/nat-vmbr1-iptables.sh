#!/bin/bash
# NAT rules for vmbr1 internal bridge (CT 107 — guiasdealicante-dev)
# Run on PVE host to restore rules after reboot if iptables-persistent is not installed.
# Rules should be persisted with: iptables-save > /etc/iptables/rules.v4

iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o vmbr0 -j MASQUERADE
iptables -A FORWARD -i vmbr1 -o vmbr0 -j ACCEPT
iptables -A FORWARD -i vmbr0 -o vmbr1 -m state --state RELATED,ESTABLISHED -j ACCEPT
