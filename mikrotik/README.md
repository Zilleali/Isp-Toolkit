# 🔴 MikroTik Scripts & Configurations

This folder contains production-ready MikroTik RouterOS scripts for ISP deployments. All scripts are written in native RouterOS script syntax (`.rsc`) and can be imported directly via Winbox or terminal.

---

## 📂 Files

| File | Description |
|---|---|
| `pppoe-server-setup.rsc` | Complete PPPoE server setup with IP pool, profiles, and NAT |
| `firewall-rules.rsc` | ISP-grade firewall (input/forward/NAT) with connection tracking |
| `bandwidth-management.rsc` | Simple Queues + PCQ Queue Tree for per-user bandwidth control |
| `hotspot-config.rsc` | Full Hotspot setup with user profiles, DHCP, walled garden |

---

## ⚡ How to Import

**Method 1 — Winbox:**
1. Open **Files** in Winbox
2. Drag and drop the `.rsc` file
3. Open **Terminal** → `/import file-name=filename.rsc`

**Method 2 — SSH/Terminal:**
```bash
scp pppoe-server-setup.rsc admin@192.168.1.1:/
ssh admin@192.168.1.1 "/import file-name=pppoe-server-setup.rsc"
```

**Method 3 — FTP Upload:**
Upload to MikroTik's root file system, then import via terminal.

---

## ⚠️ Before You Import

- Always read the comments at the top of each script — they list what to customize (interface names, IP ranges, credentials).
- Test on a **dev/lab router** before applying to production.
- Take a config backup first: `/system backup save name=pre-import-backup`
- Scripts are additive — they do not remove existing configs. Check for conflicts with existing rules.

---

## 📋 Tested On

- RouterOS **v6.49.x** (stable)
- RouterOS **v7.x** (long-term / stable)
- Hardware: MikroTik hAP ac², RB750Gr3, RB4011, CCR series

---

## 🔗 Related

- [FreeRADIUS Integration](../freeradius/) — Connect PPPoE users to a RADIUS backend
- [Bandwidth Management Docs](../docs/) — Theory and planning guide
- [Monitoring Setup](../monitoring/) — SNMP + Zabbix for MikroTik

---

> Scripts are provided as-is. Always adapt to your specific network topology before deploying.
