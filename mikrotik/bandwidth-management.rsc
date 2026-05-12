# =============================================================================
# Bandwidth Management — MikroTik RouterOS
# Author  : Zill E Ali (MTCNA) | zilleali.com
# Version : 1.0
# Tested  : RouterOS v6.49.x / v7.x
# =============================================================================
# USAGE:
#   /import file-name=bandwidth-management.rsc
#
# Two approaches included:
#   A) Simple Queues   — Easy setup, per-user limits (good for small ISPs)
#   B) Queue Tree (PCQ) — Scalable, fair-share per interface (recommended)
#
# Uncomment the section you want to use.
# =============================================================================


# =============================================================================
# APPROACH A — SIMPLE QUEUES (per user)
# Best for: Small ISPs, per-PPPoE-user speed limits
# =============================================================================

/queue simple

# 10 Mbps Down / 5 Mbps Up — Basic Plan
add name="basic-plan-user1" \
    target=192.168.100.10/32 \
    max-limit=10M/5M \
    comment="Basic Plan — 10M/5M"

# 20 Mbps Down / 10 Mbps Up — Standard Plan
add name="standard-plan-user2" \
    target=192.168.100.11/32 \
    max-limit=20M/10M \
    comment="Standard Plan — 20M/10M"

# 50 Mbps Down / 25 Mbps Up — Premium Plan
add name="premium-plan-user3" \
    target=192.168.100.12/32 \
    max-limit=50M/25M \
    comment="Premium Plan — 50M/25M"


# =============================================================================
# APPROACH B — QUEUE TREE WITH PCQ (Per Connection Queuing)
# Best for: Medium/Large ISPs — fair bandwidth sharing
# =============================================================================

# Step 1: Mangle — Mark all download & upload connections
/ip firewall mangle

add chain=forward \
    in-interface=ether1 \
    action=mark-connection \
    new-connection-mark=isp-download \
    passthrough=yes \
    comment="Mark download connections"

add chain=forward \
    connection-mark=isp-download \
    action=mark-packet \
    new-packet-mark=pkt-download \
    passthrough=no \
    comment="Mark download packets"

add chain=forward \
    in-interface=ether2 \
    action=mark-connection \
    new-connection-mark=isp-upload \
    passthrough=yes \
    comment="Mark upload connections"

add chain=forward \
    connection-mark=isp-upload \
    action=mark-packet \
    new-packet-mark=pkt-upload \
    passthrough=no \
    comment="Mark upload packets"


# Step 2: PCQ Queues (fairness per subscriber)
/queue type

add name=pcq-download \
    kind=pcq \
    pcq-rate=10M \
    pcq-classifier=dst-address \
    comment="PCQ Download — 10M per user"

add name=pcq-upload \
    kind=pcq \
    pcq-rate=5M \
    pcq-classifier=src-address \
    comment="PCQ Upload — 5M per user"


# Step 3: Queue Tree
/queue tree

add name=download-tree \
    parent=ether2 \
    packet-mark=pkt-download \
    queue=pcq-download \
    max-limit=100M \
    comment="Total Download Limit — 100M shared"

add name=upload-tree \
    parent=ether1 \
    packet-mark=pkt-upload \
    queue=pcq-upload \
    max-limit=50M \
    comment="Total Upload Limit — 50M shared"


# =============================================================================
# BURST CONFIGURATION (optional — for plans with burst)
# Apply on simple queue entries to allow temporary speed bursts
# =============================================================================

# Example: 10M plan with burst to 20M for 10 seconds
# /queue simple
# add name="burst-plan-user" \
#     target=192.168.100.20/32 \
#     max-limit=10M/5M \
#     burst-limit=20M/10M \
#     burst-threshold=7M/3M \
#     burst-time=10s/10s \
#     comment="10M Plan with 20M Burst"


# =============================================================================
# VERIFICATION:
#   /queue simple print stats
#   /queue tree print stats
#   /ip firewall mangle print stats
# =============================================================================
