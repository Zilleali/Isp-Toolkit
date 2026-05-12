# =============================================================================
# PPPoE Server Setup — MikroTik RouterOS
# Author  : Zill E Ali (MTCNA) | zilleali.com
# Version : 1.0
# Tested  : RouterOS v6.49.x / v7.x
# =============================================================================
# USAGE:
#   Upload this file to MikroTik Files, then run:
#   /import file-name=pppoe-server-setup.rsc
#
# BEFORE IMPORTING:
#   1. Replace "ether1" with your actual WAN interface
#   2. Replace "ether2" with your actual LAN/PPPoE interface
#   3. Adjust IP pool range to match your plan
#   4. Update DNS servers as needed
# =============================================================================


# --- Step 1: Create IP Pool for PPPoE Clients ---
/ip pool
add name=pppoe-pool ranges=192.168.100.2-192.168.100.254 comment="PPPoE Client Pool"


# --- Step 2: PPP Profile ---
/ppp profile
add name=isp-standard \
    local-address=192.168.100.1 \
    remote-address=pppoe-pool \
    dns-server=8.8.8.8,8.8.4.4 \
    use-compression=no \
    use-encryption=no \
    only-one=yes \
    comment="Standard ISP PPPoE Profile"


# --- Step 3: PPPoE Server (on LAN interface) ---
/interface pppoe-server server
add interface=ether2 \
    service-name=isp-pppoe \
    default-profile=isp-standard \
    authentication=chap,mschap2 \
    enabled=yes \
    max-sessions=500 \
    comment="Main PPPoE Server"


# --- Step 4: Sample PPPoE Users ---
# Remove or replace these with real credentials
/ppp secret
add name=testuser1 password=Test@1234 profile=isp-standard service=pppoe comment="Test Account 1"
add name=testuser2 password=Test@5678 profile=isp-standard service=pppoe comment="Test Account 2"


# --- Step 5: NAT Masquerade (WAN outbound) ---
/ip firewall nat
add chain=srcnat out-interface=ether1 action=masquerade comment="PPPoE NAT — WAN Masquerade"


# --- Step 6: IP Forwarding (ensure routing works) ---
/ip settings
set ip-forward=yes


# =============================================================================
# VERIFICATION COMMANDS (run manually after import):
#
#   /interface pppoe-server server print
#   /ppp secret print
#   /ip pool print
#   /ppp active print        <- shows connected sessions
# =============================================================================
