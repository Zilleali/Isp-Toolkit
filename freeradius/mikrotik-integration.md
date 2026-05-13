# MikroTik + FreeRADIUS Integration Guide

**Author:** Zill E Ali (MTCNA) | [zilleali.com](https://zilleali.com)  
**Stack:** MikroTik RouterOS v6.49+/v7.x + FreeRADIUS 3.x + Ubuntu 22.04/24.04

---

## Overview

This guide connects a MikroTik PPPoE server to a FreeRADIUS backend for centralized authentication, authorization, and accounting (AAA). All subscriber credentials are managed on the RADIUS server — not locally on the router.

```
[PPPoE Client]
      |
      | PPPoE (CHAP/MSCHAPv2)
      ↓
[MikroTik Router]  ——RADIUS Auth Request——→  [FreeRADIUS Server]
      |                                               |
      |          ←——Access-Accept / Reject——          |
      ↓
[Internet]
```

---

## Part 1 — FreeRADIUS Server Setup

### 1.1 Install FreeRADIUS

```bash
sudo apt update
sudo apt install freeradius freeradius-utils -y
```

### 1.2 Verify Installation

```bash
sudo freeradius -v
# Expected: FreeRADIUS Version 3.x.x
```

### 1.3 Enable MikroTik Dictionary

FreeRADIUS needs MikroTik VSA (Vendor Specific Attributes) for rate limiting:

```bash
# Check if dictionary exists
grep -i mikrotik /usr/share/freeradius/dictionary

# It should be included by default in FreeRADIUS 3.x
# If missing, add to /etc/freeradius/3.0/dictionary:
# $INCLUDE /usr/share/freeradius/dictionary.mikrotik
```

### 1.4 Configure Clients (NAS)

Edit `/etc/freeradius/3.0/clients.conf` — add your MikroTik router:

```
client mikrotik-main {
    ipaddr  = 192.168.1.1        # Your MikroTik IP
    secret  = Str0ng$ecret!MK1   # Must match MikroTik RADIUS secret
    nastype = other
}
```

### 1.5 Add Test User

Edit `/etc/freeradius/3.0/users`:

```
testuser1   Cleartext-Password := "Test@1234"
            Service-Type = Framed-User,
            Framed-Protocol = PPP,
            Framed-IP-Address = 255.255.255.254,
            Mikrotik-Rate-Limit = "10M/5M"
```

### 1.6 Test Configuration

```bash
sudo freeradius -XC        # Config syntax check
sudo freeradius -X         # Run in debug mode (watch output)
```

### 1.7 Start & Enable Service

```bash
sudo systemctl enable freeradius
sudo systemctl start freeradius
sudo systemctl status freeradius
```

---

## Part 2 — MikroTik RADIUS Configuration

### 2.1 Add RADIUS Server in MikroTik

**Via Winbox:** Go to RADIUS → Add  
**Via Terminal:**

```routeros
/radius
add address=192.168.1.100 \
    secret=Str0ng$ecret!MK1 \
    service=ppp \
    authentication-port=1812 \
    accounting-port=1813 \
    timeout=3000 \
    comment="FreeRADIUS Server"
```

### 2.2 Enable RADIUS on PPP

```routeros
/ppp aaa
set use-radius=yes \
    accounting=yes \
    interim-update=5m
```

### 2.3 PPP Profile — Use RADIUS

Ensure your PPP profile does NOT hardcode local IPs (let RADIUS handle it):

```routeros
/ppp profile
add name=radius-profile \
    local-address=192.168.100.1 \
    remote-address=pppoe-pool \
    use-compression=no \
    only-one=yes \
    comment="RADIUS-authenticated profile"
```

### 2.4 PPPoE Server — Use RADIUS Profile

```routeros
/interface pppoe-server server
set [find name=isp-pppoe] default-profile=radius-profile
```

---

## Part 3 — Testing the Integration

### 3.1 Test from RADIUS Server (radtest)

```bash
# Format: radtest <user> <pass> <radius-ip> <nas-port> <secret>
radtest testuser1 Test@1234 127.0.0.1 0 testing123
```

**Expected output:**
```
Sent Access-Request Id 1 from 0.0.0.0:PORT to 127.0.0.1:1812
        User-Name = "testuser1"
        ...
Received Access-Accept Id 1 from 127.0.0.1:1812
        Mikrotik-Rate-Limit = "10M/5M"
```

### 3.2 Test PPPoE from a Client

Connect a PPPoE client using `testuser1` / `Test@1234` — it should authenticate via RADIUS and get assigned the rate limit `10M/5M`.

### 3.3 Check Active Sessions on MikroTik

```routeros
/ppp active print
```

### 3.4 Check RADIUS Logs

```bash
sudo tail -f /var/log/freeradius/radius.log
```

---

## Part 4 — Accounting (Track Usage)

FreeRADIUS can log session data (start/stop/bytes) to a flat file or SQL database.

### 4.1 Flat File Accounting (default)

Logs are stored in:
```
/var/log/freeradius/radacct/<nas-ip>/detail-<date>
```

View live:
```bash
sudo tail -f /var/log/freeradius/radacct/192.168.1.1/detail-$(date +%Y%m%d)
```

### 4.2 SQL Accounting (recommended for production)

```bash
# Install PostgreSQL module
sudo apt install freeradius-postgresql -y

# Enable SQL module
cd /etc/freeradius/3.0/mods-enabled
sudo ln -s ../mods-available/sql sql

# Edit sql module config
sudo nano /etc/freeradius/3.0/mods-available/sql
# Set: driver = "rlm_sql_postgresql"
# Set: server, port, login, password, radius_db
```

---

## Part 5 — Troubleshooting

| Problem | Likely Cause | Fix |
|---|---|---|
| `Access-Reject` on valid user | Wrong secret or user not in `users` file | Check `clients.conf` secret, verify username |
| MikroTik shows `radius timeout` | Firewall blocking UDP 1812/1813 | Allow RADIUS ports on server firewall |
| Rate limit not applied | Missing MikroTik dictionary | Verify VSA dictionary is loaded |
| No accounting data | `accounting=yes` not set on MikroTik | `/ppp aaa set accounting=yes` |
| FreeRADIUS won't start | Config syntax error | Run `sudo freeradius -XC` |

### Firewall — Allow RADIUS Ports (Ubuntu UFW)

```bash
sudo ufw allow from 192.168.1.1 to any port 1812 proto udp
sudo ufw allow from 192.168.1.1 to any port 1813 proto udp
```

---

## Quick Reference

| Item | Value |
|---|---|
| Auth Port | UDP 1812 |
| Accounting Port | UDP 1813 |
| Config Dir | `/etc/freeradius/3.0/` |
| Log File | `/var/log/freeradius/radius.log` |
| Accounting Dir | `/var/log/freeradius/radacct/` |
| Test Command | `radtest user pass 127.0.0.1 0 secret` |
| Debug Mode | `sudo freeradius -X` |

---

> For SQL backend integration (PostgreSQL/MySQL) and multi-NAS setups, see [docs/isp-from-scratch.md](../docs/isp-from-scratch.md)