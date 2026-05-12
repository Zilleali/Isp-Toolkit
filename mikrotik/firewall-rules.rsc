# =============================================================================
# ISP-Grade Firewall Rules — MikroTik RouterOS
# Author  : Zill E Ali (MTCNA) | zilleali.com
# Version : 1.0
# Tested  : RouterOS v6.49.x / v7.x
# =============================================================================
# USAGE:
#   /import file-name=firewall-rules.rsc
#
# NOTES:
#   - Replace "ether1" with your WAN interface
#   - Replace "pppoe-out1" if using PPPoE uplink
#   - Review and adjust rules before applying to production
#   - Rules are ordered — sequence matters!
# =============================================================================


# =============================================================================
# FILTER RULES — INPUT (Protect the router itself)
# =============================================================================
/ip firewall filter

# Allow established & related connections
add chain=input connection-state=established,related action=accept \
    comment="Allow established/related"

# Drop invalid packets
add chain=input connection-state=invalid action=drop \
    comment="Drop invalid packets"

# Allow ICMP (ping) — limit to prevent flood
add chain=input protocol=icmp limit=50/5s,2:packet action=accept \
    comment="Allow ICMP (rate-limited)"

add chain=input protocol=icmp action=drop \
    comment="Drop excess ICMP"

# Allow management from trusted LAN only
add chain=input src-address=192.168.1.0/24 action=accept \
    comment="Allow LAN management access"

# Allow Winbox from LAN
add chain=input protocol=tcp dst-port=8291 src-address=192.168.1.0/24 action=accept \
    comment="Allow Winbox from LAN"

# Allow SSH from LAN only
add chain=input protocol=tcp dst-port=22 src-address=192.168.1.0/24 action=accept \
    comment="Allow SSH from LAN"

# Block all other input
add chain=input action=drop \
    comment="Drop all other input"


# =============================================================================
# FILTER RULES — FORWARD (Client traffic control)
# =============================================================================

# Allow established & related
add chain=forward connection-state=established,related action=accept \
    comment="Forward: allow established/related"

# Drop invalid
add chain=forward connection-state=invalid action=drop \
    comment="Forward: drop invalid"

# Drop clients accessing router's management
add chain=forward dst-address=192.168.1.1 action=drop \
    comment="Block clients from accessing router directly"

# Block common malicious ports (optional — uncomment as needed)
# add chain=forward protocol=tcp dst-port=135-139,445 action=drop \
#     comment="Block Windows exploit ports"

# Allow all other forward traffic (NAT handles internet access)
add chain=forward action=accept \
    comment="Allow remaining forwarded traffic"


# =============================================================================
# NAT RULES
# =============================================================================
/ip firewall nat

# Masquerade all outbound traffic on WAN
add chain=srcnat out-interface=ether1 action=masquerade \
    comment="WAN Masquerade / NAT"


# =============================================================================
# CONNECTION TRACKING — Performance tuning
# =============================================================================
/ip firewall connection tracking
set enabled=yes tcp-established-timeout=1d udp-timeout=10s


# =============================================================================
# VERIFICATION:
#   /ip firewall filter print stats
#   /ip firewall nat print stats
#   /ip firewall connection print count-only
# =============================================================================
