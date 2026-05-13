# 🟠 FreeRADIUS Configuration Templates

This folder contains production-ready FreeRADIUS 3.x configuration files and integration guides for ISP deployments — specifically optimized for MikroTik PPPoE authentication.

---

## 📂 Files

| File | Description |
|---|---|
| `users.conf` | Sample user definitions with rate limits, static IPs, session timeouts |
| `clients.conf` | NAS client config — MikroTik routers, hotspot, Cisco switches |
| `radiusd.conf` | Base RADIUS server config — logging, security, thread pool |
| `mikrotik-integration.md` | Step-by-step guide: connect MikroTik PPPoE → FreeRADIUS |

---

## ⚡ Quick Start

### Install FreeRADIUS

```bash
sudo apt update
sudo apt install freeradius freeradius-utils -y
```

### Apply Configs

```bash
# Backup originals first
sudo cp /etc/freeradius/3.0/clients.conf /etc/freeradius/3.0/clients.conf.bak
sudo cp /etc/freeradius/3.0/users /etc/freeradius/3.0/users.bak

# Copy sample configs
sudo cp clients.conf /etc/freeradius/3.0/clients.conf
sudo cp users.conf /etc/freeradius/3.0/users
```

### Test & Start

```bash
sudo freeradius -XC          # Syntax check
sudo freeradius -X           # Debug mode — watch auth logs live
sudo systemctl start freeradius
```

### Test Authentication

```bash
radtest testuser1 Test@1234 127.0.0.1 0 testing123
# Expected: Access-Accept
```

---

## 🔗 MikroTik Integration

For full step-by-step setup connecting MikroTik PPPoE to FreeRADIUS:

→ **[mikrotik-integration.md](mikrotik-integration.md)**

Covers:
- FreeRADIUS server setup
- MikroTik RADIUS client configuration
- Per-user bandwidth control via `Mikrotik-Rate-Limit` VSA
- Accounting (flat file + SQL)
- Troubleshooting table

---

## 📋 Tested On

- FreeRADIUS **3.0.x** / **3.2.x**
- Ubuntu **22.04 LTS** / **24.04 LTS**
- MikroTik RouterOS **v6.49.x** / **v7.x**

---

## 🔗 Related

- [MikroTik PPPoE Scripts](../mikrotik/) — PPPoE server configs
- [Scripts](../scripts/) — Python bandwidth report & IP allocation tools
- [Docs](../docs/) — Full ISP from Scratch guide

---

> Always run `sudo freeradius -XC` before restarting the service. Never edit production configs without a backup.