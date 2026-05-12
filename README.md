# 🌐 ISP Toolkit

> A comprehensive, production-ready toolkit for building, managing, and troubleshooting Internet Service Providers — from MikroTik configs to RADIUS setup to FTTH deployment guides.

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![MikroTik](https://img.shields.io/badge/MikroTik-RouterOS-blue)](https://mikrotik.com)
[![FreeRADIUS](https://img.shields.io/badge/FreeRADIUS-3.x-orange)](https://freeradius.org)
[![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen)](https://github.com/Zilleali/isp-toolkit)

---

## 📌 About

**ISP Toolkit** is an open-source collection of scripts, configuration templates, guides, and automation tools for network engineers and ISP operators. Whether you're building an ISP from scratch or managing an existing network, this repo has practical, real-world resources.

Built and maintained by **[Zill E Ali](https://zilleali.com)** — MTCNA Certified Network Engineer with hands-on ISP deployment experience in Pakistan.

---

## 📁 Repository Structure

```
isp-toolkit/
│
├── mikrotik/               # MikroTik RouterOS scripts & configs
├── freeradius/             # FreeRADIUS configuration templates
├── monitoring/             # Network monitoring setup guides
├── ftth-fiber/             # FTTH/Fiber deployment guides
├── scripts/                # Automation scripts (Bash, Python)
└── docs/                   # ISP setup documentation
```

---

## 🚀 What's Inside

### 🔴 MikroTik (`/mikrotik`)
- PPPoE Server Setup
- Firewall Rules (ISP-grade)
- Bandwidth Management (Queue Trees / Simple Queues)
- Hotspot Configuration
- VLAN Setup for ISPs

### 🟠 FreeRADIUS (`/freeradius`)
- `users.conf` — sample user definitions
- `clients.conf` — NAS client configuration
- `radiusd.conf` — base RADIUS server config
- Integration guide with MikroTik PPPoE

### 🟡 Monitoring (`/monitoring`)
- SNMP setup on MikroTik
- The Dude / Zabbix integration notes
- Uptime & bandwidth alerting

### 🟢 FTTH & Fiber (`/ftth-fiber`)
- OLT Configuration Guide (GPON basics)
- Optical Splitter Ratio Calculator
- Fiber splicing & termination best practices
- Link budget calculation template

### 🔵 Scripts (`/scripts`)
- `ip-allocation.sh` — IP block management
- `bandwidth-report.py` — Daily usage report generator
- `pppoe-audit.rsc` — Active session checker for MikroTik

### 📄 Docs (`/docs`)
- **ISP from Scratch** — End-to-end ISP setup guide (Layer 1 → Layer 3)
- **Troubleshooting Guide** — Common ISP issues and fixes
- **PPPoE vs DHCP** — When to use what

---

## ⚡ Quick Start

### Clone the Repo
```bash
git clone https://github.com/Zilleali/isp-toolkit.git
cd isp-toolkit
```

### Using MikroTik Scripts
Upload `.rsc` files via Winbox or import via terminal:
```bash
/import file-name=pppoe-server-setup.rsc
```

### FreeRADIUS Setup
```bash
# Copy sample configs
cp freeradius/clients.conf /etc/freeradius/3.0/clients.conf
cp freeradius/users.conf /etc/freeradius/3.0/users

# Test config
sudo freeradius -XC
```

---

## 🛠️ Tech Stack & Tools

| Category | Tools |
|---|---|
| Router OS | MikroTik RouterOS v6/v7 |
| AAA Server | FreeRADIUS 3.x |
| Monitoring | Zabbix, The Dude, SNMP |
| Scripting | Bash, Python 3, RouterOS Script |
| FTTH | GPON OLT/ONT |
| Virtualization | Proxmox VE |

---

## 📋 Prerequisites

- MikroTik router with RouterOS v6.49+ or v7.x
- Linux server (Ubuntu 22.04/24.04 recommended) for RADIUS
- Basic networking knowledge (CIDR, NAT, VLANs, PPPoE)
- Winbox or SSH access to your MikroTik

---

## 🤝 Contributing

Contributions are welcome! If you have:
- A useful MikroTik script
- A better RADIUS config
- An ISP deployment guide

Please open a PR or issue. Let's build the best ISP resource together.

```bash
# Fork → Clone → Branch → Commit → PR
git checkout -b feature/your-feature-name
```

---

## 📜 License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.
Free to use, modify, and distribute. Attribution appreciated.

---

## 👤 Author

**Zill E Ali**
- 🌐 Website: [zilleali.com](https://zilleali.com)
- 💼 LinkedIn: [linkedin.com/in/zilleali12](https://linkedin.com/in/zilleali12)
- 🐙 GitHub: [github.com/Zilleali](https://github.com/Zilleali)
- 🎯 Fiverr: [fiverr.com/zillealibutt](https://fiverr.com/zillealibutt)
- 📧 Email: zilleali1245@gmail.com

---

> ⭐ **If this toolkit helped you, give it a star!** It helps others find this resource.
