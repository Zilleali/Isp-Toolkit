# =============================================================================
# Hotspot Configuration — MikroTik RouterOS
# Author  : Zill E Ali (MTCNA) | zilleali.com
# Version : 1.0
# Tested  : RouterOS v6.49.x / v7.x
# =============================================================================
# USAGE:
#   /import file-name=hotspot-config.rsc
#
# BEFORE IMPORTING:
#   1. Replace "ether3" with your hotspot-facing interface (LAN/WiFi)
#   2. Adjust IP range if needed
#   3. Add real hotspot users in Step 5
#   4. Customize portal DNS name in Step 2
# =============================================================================


# --- Step 1: IP Address on Hotspot Interface ---
/ip address
add address=10.10.0.1/24 interface=ether3 comment="Hotspot Gateway"


# --- Step 2: DHCP Server for Hotspot Clients ---
/ip pool
add name=hotspot-pool ranges=10.10.0.2-10.10.0.254 comment="Hotspot IP Pool"

/ip dhcp-server
add name=hotspot-dhcp \
    interface=ether3 \
    address-pool=hotspot-pool \
    lease-time=1h \
    disabled=no \
    comment="Hotspot DHCP Server"

/ip dhcp-server network
add address=10.10.0.0/24 \
    gateway=10.10.0.1 \
    dns-server=8.8.8.8,8.8.4.4 \
    comment="Hotspot DHCP Network"


# --- Step 3: Hotspot Server Profile ---
/ip hotspot profile
add name=hsprof1 \
    hotspot-address=10.10.0.1 \
    dns-name=hotspot.isp.local \
    html-directory=hotspot \
    http-cookie-lifetime=3d \
    smtp-server=0.0.0.0 \
    login-by=cookie,http-chap \
    comment="Default Hotspot Profile"


# --- Step 4: Hotspot Server ---
/ip hotspot
add name=hotspot1 \
    interface=ether3 \
    address-pool=hotspot-pool \
    profile=hsprof1 \
    disabled=no \
    comment="Main Hotspot Server"


# --- Step 5: Hotspot Users ---
/ip hotspot user

# Free 1-hour trial user
add name=trial \
    password=trial123 \
    profile=default \
    limit-uptime=1h \
    comment="Trial User — 1 hour"

# Voucher-style user (24h access)
add name=voucher001 \
    password=Abc@9876 \
    profile=default \
    limit-uptime=24h \
    comment="24h Voucher"

# Staff/unlimited user
add name=staff \
    password=Staff@Secure1 \
    profile=default \
    comment="Staff — Unlimited"


# --- Step 6: Hotspot User Profiles (speed limits per tier) ---
/ip hotspot user profile

add name=free-tier \
    rate-limit=2M/1M \
    session-timeout=1h \
    shared-users=1 \
    comment="Free Tier — 2M/1M, 1 hour"

add name=paid-tier \
    rate-limit=10M/5M \
    session-timeout=24h \
    shared-users=1 \
    comment="Paid Tier — 10M/5M, 24 hours"

add name=premium-tier \
    rate-limit=25M/10M \
    session-timeout=0s \
    shared-users=1 \
    comment="Premium — 25M/10M, Unlimited"


# =============================================================================
# WALLED GARDEN (Allow access without login — e.g., payment page)
# =============================================================================
/ip hotspot walled-garden
add dst-host=payment.yourportal.com action=allow comment="Allow payment portal pre-login"
add dst-host=*.googleapis.com action=allow comment="Allow Google APIs"


# =============================================================================
# VERIFICATION:
#   /ip hotspot print
#   /ip hotspot user print
#   /ip hotspot active print      <- live sessions
#   /ip hotspot host print        <- all detected hosts
# =============================================================================
