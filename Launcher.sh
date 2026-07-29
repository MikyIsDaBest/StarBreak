#!/usr/bin/env bash

# Lock script directory so paths remain relative to launcher.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Ensure directories exist
mkdir -p plugins logs reports output

# ==================== ASCII BANNERS ====================
BANNER_NMAP="
┌─────────────────────────────────────────────────────┐
│   ███╗   ██╗███╗   ███╗ █████╗ ██████╗              │
│   ████╗  ██║████╗ ████║██╔══██╗██╔══██╗             │
│   ██╔██╗ ██║██╔████╔██║███████║██████╔╝             │
│   ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝              │
│   ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║                  │
│   ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝                  │
│            PORT SCANNER                             │
└─────────────────────────────────────────────────────┘"

BANNER_WIRESHARK="
┌─────────────────────────────────────────────────────┐
│   ╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗                 │
│   ╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║                 │
│   ╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝                 │
│            PACKET CAPTURE                           │
└─────────────────────────────────────────────────────┘"

BANNER_NSLOOKUP="
┌─────────────────────────────────────────────────────┐
│   ███╗   ██╗███████╗██╗      ██████╗  ██████╗     │
│   ████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗    │
│   ██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║    │
│   ██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║    │
│   ██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝    │
│   ╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝     │
│            DNS LOOKUP                               │
└─────────────────────────────────────────────────────┘"

BANNER_TCPSCANNER="
┌─────────────────────────────────────────────────────┐
│    ████████╗ ██████╗██████╗                         │
│    ╚══██╔══╝██╔════╝██╔══██╗                        │
│       ██║   ██║     ██████╔╝                        │
│       ██║   ██║     ██╔═══╝                         │
│       ██║   ╚██████╗██║                             │
│       ╚═╝    ╚═════╝╚═╝                             │
│            PORT SCANNER                             │
└─────────────────────────────────────────────────────┘"

BANNER_SUBDOMAIN="
┌─────────────────────────────────────────────────────┐
│   ███████╗██╗   ██╗██████╗ ██████╗  ██████╗        │
│   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗       │
│   ███████╗██║   ██║██████╔╝██║  ██║██║   ██║       │
│   ╚════██║██║   ██║██╔══██╗██║  ██║██║   ██║       │
│   ███████║╚██████╔╝██████╔╝██████╔╝╚██████╔╝       │
│   ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝        │
│            SUBDOMAIN ENUMERATION                    │
└─────────────────────────────────────────────────────┘"

BANNER_SHERLOCK="
┌─────────────────────────────────────────────────────┐
│    ███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗ │
│    ██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗│
│    ███████╗███████║█████╗  ██████╔╝██║     ██║   ██║│
│    ╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║│
│    ███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝│
│    ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ │
│            OSINT LOOKUP                             │
└─────────────────────────────────────────────────────┘"

BANNER_STARHUNT="
┌─────────────────────────────────────────────────────┐
│    ███████╗████████╗ █████╗ ██████╗                 │
│    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗                │
│    ███████╗   ██║   ███████║██████╔╝                │
│    ╚════██║   ██║   ██╔══██║██╔══██╗                │
│    ███████║   ██║   ██║  ██║██║  ██║                │
│    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝                │
│    ██╗  ██╗██╗   ██╗███╗   ██╗████████╗             │
│    ██║  ██║██║   ██║████╗  ██║╚══██╔══╝             │
│    ███████║██║   ██║██╔██╗ ██║   ██║                │
│    ██╔══██║██║   ██║██║╚██╗██║   ██║                │
│    ██║  ██║╚██████╔╝██║ ╚████║   ██║                │
│    ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝                │
│            ADVANCED OSINT - 50+ PLATFORMS           │
└─────────────────────────────────────────────────────┘"

BANNER_BREACH="
┌─────────────────────────────────────────────────────┐
│   ██████╗ ██████╗ ███████╗ █████╗  ██████╗██╗  ██╗  │
│   ██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║  │
│   ██████╔╝██████╔╝█████╗  ███████║██║     ███████║  │
│   ██╔══██╗██╔══██╗██╔══╝  ██╔══██║██║     ██╔══██║  │
│   ██████╔╝██║  ██║███████╗██║  ██║╚██████╗██║  ██║  │
│   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝  │
│            BREACH CHECKER ENGINE                    │
└─────────────────────────────────────────────────────┘"

BANNER_EMAIL="
┌─────────────────────────────────────────────────────┐
│   ███████╗███╗   ███╗ █████╗ ██╗██╗                 │
│   ██╔════╝████╗ ████║██╔══██╗██║██║                 │
│   █████╗  ██╔████╔██║███████║██║██║                 │
│   ██╔══╝  ██║╚██╔╝██║██╔══██║██║██║                 │
│   ███████╗██║ ╚═╝ ██║██║  ██║██║███████╗            │
│   ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝            │
│            EMAIL HUNTER ENGINE                      │
└─────────────────────────────────────────────────────┘"

BANNER_STARSTRIKE="
┌─────────────────────────────────────────────────────┐
│    ███████╗████████╗ █████╗ ██████╗ ███████╗████████╗
│    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
│    ███████╗   ██║   ███████║██████╔╝███████╗   ██║   │
│    ╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║   │
│    ███████║   ██║   ██║  ██║██║  ██║███████║   ██║   │
│    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   │
│             STRIKE ENGINE                           │
└─────────────────────────────────────────────────────┘"

BANNER_METEOR="
┌─────────────────────────────────────────────────────┐
│   ███╗   ███╗████████╗████████╗███████╗██████╗      │
│   ████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗     │
│   ██╔████╔██║   ██║      ██║   █████╗  ██████╔╝     │
│   ██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗     │
│   ██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║     │
│   ╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝     │
│    ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗     │
│    ██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝     │
│    ███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗     │
│    ╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║     │
│    ███████║   ██║   ██║  ██║██║██║  ██╗███████║     │
│    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝     │
└─────────────────────────────────────────────────────┘"

BANNER_EXPLOIT="
┌─────────────────────────────────────────────────────┐
│   ███████╗██╗  ██╗██████╗ ██╗      ██████╗ ██╗████████╗
│   ██╔════╝╚██╗██╔╝██╔══██╗██║     ██╔═══██╗██║╚══██╔══╝
│   █████╗   ╚███╔╝ ██████╔╝██║     ██║   ██║██║   ██║   │
│   ██╔══╝   ██╔██╗ ██╔═══╝ ██║     ██║   ██║██║   ██║   │
│   ███████╗██╔╝ ██╗██║     ███████╗╚██████╔╝██║   ██║   │
│   ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝ ╚═╝   ╚═╝   │
│            EXPLOIT SUGGESTER                        │
└─────────────────────────────────────────────────────┘"

BANNER_AIRCRACK="
┌─────────────────────────────────────────────────────┐
│    █████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗
│   ██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝
│   ███████║██║██████╔╝██║     ██████╔╝███████║██║     
│   ██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║     
│   ██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗
│   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
│            WIRELESS SECURITY                        │
└─────────────────────────────────────────────────────┘"

BANNER_SATELLITE="
┌─────────────────────────────────────────────────────┐
│   ███████╗ █████╗ ████████╗███████╗██╗     ██╗      │
│   ██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║     ██║      │
│   ███████╗███████║   ██║   █████╗  ██║     ██║      │
│   ╚════██║██╔══██║   ██║   ██╔══╝  ██║     ██║      │
│   ███████║██║  ██║   ██║   ███████╗███████╗███████╗ │
│   ╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝ │
│    ███████╗██████╗  █████╗ ██████╗  ██████╗         │
│    ██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗        │
│    ███████╗██████╔╝███████║██████╔╝██║   ██║        │
│    ╚════██║██╔══██╗██╔══██║██╔══██╗██║   ██║        │
│    ███████║██║  ██║██║  ██║██║  ██║╚██████╔╝        │
│    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝         │
│            SATELLITE RECONNAISSANCE                 │
└─────────────────────────────────────────────────────┘"

BANNER_PROXY="
┌─────────────────────────────────────────────────────┐
│   ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗        │
│   ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝        │
│   ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝         │
│   ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝          │
│   ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║           │
│   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝           │
│            PROXY/ANONYMITY ENGINE                   │
└─────────────────────────────────────────────────────┘"

BANNER_STEGANO="
┌─────────────────────────────────────────────────────┐
│   ███████╗████████╗███████╗ ██████╗  █████╗         │
│   ██╔════╝╚══██╔══╝██╔════╝██╔════╝ ██╔══██╗        │
│   ███████╗   ██║   █████╗  ██║  ███╗███████║        │
│   ╚════██║   ██║   ██╔══╝  ██║   ██║██╔══██║        │
│   ███████║   ██║   ███████╗╚██████╔╝██║  ██║        │
│   ╚══════╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═╝  ╚═╝        │
│            STEGANOGRAPHY SUITE                      │
└─────────────────────────────────────────────────────┘"

BANNER_CUPP="
┌─────────────────────────────────────────────────────┐
│    ██████╗██╗   ██╗██████╗ ██████╗                  │
│   ██╔════╝██║   ██║██╔══██╗██╔══██╗                 │
│   ██║     ██║   ██║██████╔╝██████╔╝                 │
│   ██║     ██║   ██║██╔═══╝ ██╔═══╝                  │
│   ╚██████╗╚██████╔╝██║     ██║                      │
│    ╚═════╝ ╚═════╝ ╚═╝     ╚═╝                      │
│            PASSWORD PROFILER                        │
└─────────────────────────────────────────────────────┘"

BANNER_SMSSPOOFER="
┌─────────────────────────────────────────────────────┐
│    ███████╗███╗   ███╗███████╗                      │
│    ██╔════╝████╗ ████║██╔════╝                      │
│    ███████╗██╔████╔██║███████╗                      │
│    ╚════██║██║╚██╔╝██║╚════██║                      │
│    ███████║██║ ╚═╝ ██║███████║                      │
│    ╚══════╝╚═╝     ╚═╝╚══════╝                      │
│    ███████╗██████╗  ██████╗  ██████╗ ███████╗██████╗
│    ██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██╔══██╗
│    ███████╗██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝
│    ╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝  ██╔══██╗
│    ███████║██║     ╚██████╔╝╚██████╔╝███████╗██║  ██║
│    ╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
│            FREE SMS SPOOFING ENGINE                 │
└─────────────────────────────────────────────────────┘"

# ==================== MENU ====================
show_menu() {
    clear
    echo "================================================================="
    echo "    ____ _____  _    ____    ____  ____  _____    _    _  __ "
    echo "   / ___|_   _|/ \  |  _ \  | __ )|  _ \| ____|  / \  | |/ / "
    echo "   \___ \ | | / _ \ | |_) | |  _ \| |_) |  _|   / _ \ | ' /  "
    echo "    ___) || |/ ___ \|  _ <  | |_) |  _ <| |___ / ___ \| . \  "
    echo "   |____/ |_/_/   \_\_| \_\ |____/|_| \_\_____/_/   \_\_|\_\ "
    echo ""
    echo "                     Made by N E T W O R K 0              "
    echo "================================================================="
    echo "                     NETWORK AND SECURITY SUITE           "
    echo "================================================================="
    echo ""
    echo "   ═══ NETWORK & SCANNING ═══"
    echo "   [1]  Nmap - Port & Network Discovery"
    echo "   [2]  Wireshark - Packet Capture"
    echo "   [3]  Nslookup - DNS Lookup"
    echo "   [4]  TCP Port Scanner"
    echo "   [5]  Subdomain Enumerator"
    echo ""
    echo "   ═══ OSINT & RECON ═══"
    echo "   [6]  Sherlock - OSINT Username Lookup"
    echo "   [7]  StarHunt - Advanced OSINT (50+ Platforms)"
    echo "   [8]  Breach Checker - Database Leak Search"
    echo "   [9]  Email Hunter"
    echo ""
    echo "   ═══ EXPLOITATION & DOS ═══"
    echo "   [10] StarStrike - Guided Attack Engine"
    echo "   [11] StarStrike - Custom Raw Command"
    echo "   [12] M3T30R STR!K3 - Multi-Protocol DoS"
    echo "   [13] Exploit Suggester"
    echo ""
    echo "   ═══ WIRELESS & PHYSICAL ═══"
    echo "   [14] Aircrack-ng - Wireless Security"
    echo "   [15] Satellite Reconnaissance"
    echo ""
    echo "   ═══ ANONYMITY & STEALTH ═══"
    echo "   [16] Proxy/Anonymity Engine"
    echo "   [17] Steganography Suite"
    echo ""
    echo "   ═══ PASSWORD & CREDENTIALS ═══"
    echo "   [18] CUPP - Password Profiler"
    echo "   [19] SMS Spoofer - Free SMS Spoofing"
    echo ""
    echo "   [20] Exit"
    echo "================================================================="
}

# ==================== FUNCTIONS ====================
run_nmap() {
    clear
    echo "$BANNER_NMAP"
    echo ""
    if ! command -v nmap &> /dev/null; then
        echo "Error: Nmap is not installed. Install with: sudo apt install nmap"
        read -rp "Press Enter to continue..."
        return
    fi
    read -rp "Enter Target IP/Subnet: " TARGET
    [ -z "$TARGET" ] && return
    read -rp "Enter Scan Flags (default -F): " FLAGS
    FLAGS="${FLAGS:--F}"
    echo ""
    nmap $FLAGS "$TARGET"
    echo ""
    read -rp "Press Enter to continue..."
}

run_wireshark() {
    clear
    echo "$BANNER_WIRESHARK"
    echo ""
    if command -v wireshark &> /dev/null; then
        wireshark &
    else
        echo "Error: Wireshark not installed."
    fi
    read -rp "Press Enter to continue..."
}

run_nslookup() {
    clear
    echo "$BANNER_NSLOOKUP"
    echo ""
    read -rp "Enter Domain or IP: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    nslookup "$TARGET"
    echo ""
    read -rp "Press Enter to continue..."
}

run_tcp_scanner() {
    clear
    echo "$BANNER_TCPSCANNER"
    echo ""
    read -rp "Enter Target IP/Hostname: " TARGET
    [ -z "$TARGET" ] && return
    read -rp "Enter Start Port (default 1): " START
    START="${START:-1}"
    read -rp "Enter End Port (default 1024): " END
    END="${END:-1024}"
    echo ""
    if [ -f "plugins/tcp_scanner.py" ]; then
        python3 plugins/tcp_scanner.py --target "$TARGET" --start "$START" --end "$END"
    else
        echo "Error: plugins/tcp_scanner.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_subdomain_enum() {
    clear
    echo "$BANNER_SUBDOMAIN"
    echo ""
    read -rp "Enter Domain: " DOMAIN
    [ -z "$DOMAIN" ] && return
    read -rp "Enter Threads (default 20): " THREADS
    THREADS="${THREADS:-20}"
    echo ""
    if [ -f "plugins/subdomain_enum.py" ]; then
        python3 plugins/subdomain_enum.py --domain "$DOMAIN" --threads "$THREADS"
    else
        echo "Error: plugins/subdomain_enum.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_sherlock() {
    clear
    echo "$BANNER_SHERLOCK"
    echo ""
    read -rp "Enter Username: " USERNAME
    [ -z "$USERNAME" ] && return
    echo ""
    if command -v sherlock &> /dev/null; then
        sherlock "$USERNAME"
    elif [ -f "plugins/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock.py "$USERNAME"
    else
        echo "Error: Sherlock not found globally or in plugins/sherlock/"
    fi
    read -rp "Press Enter to continue..."
}

run_starhunt() {
    clear
    echo "$BANNER_STARHUNT"
    echo ""
    read -rp "Enter Target: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/starhunt.py" ]; then
        python3 plugins/starhunt.py "$TARGET"
    else
        echo "Error: plugins/starhunt.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_breach() {
    clear
    echo "$BANNER_BREACH"
    echo ""
    read -rp "Enter Target Query: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/breach_checker.py" ]; then
        python3 plugins/breach_checker.py "$TARGET"
    else
        echo "Error: plugins/breach_checker.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_email() {
    clear
    echo "$BANNER_EMAIL"
    echo ""
    read -rp "Enter Target Domain/Email: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/email_hunter.py" ]; then
        python3 plugins/email_hunter.py "$TARGET"
    else
        echo "Error: plugins/email_hunter.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_starstrike() {
    clear
    echo "$BANNER_STARSTRIKE"
    echo ""
    read -rp "Enter Target: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py "$TARGET"
    else
        echo "Error: plugins/starstrike.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_custom_raw() {
    clear
    echo "$BANNER_STARSTRIKE"
    echo ""
    read -rp "Enter Custom Command: " CMD
    [ -z "$CMD" ] && return
    echo ""
    if [ -f "plugins/starstrike_raw.py" ]; then
        python3 plugins/starstrike_raw.py --cmd "$CMD"
    else
        echo "Error: plugins/starstrike_raw.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_meteor() {
    clear
    echo "$BANNER_METEOR"
    echo ""
    read -rp "Enter Target IP/Hostname: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/meteor.py" ]; then
        python3 plugins/meteor.py "$TARGET"
    else
        echo "Error: plugins/meteor.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_exploit() {
    clear
    echo "$BANNER_EXPLOIT"
    echo ""
    read -rp "Enter Target System/Service: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/exploit_suggester.py" ]; then
        python3 plugins/exploit_suggester.py "$TARGET"
    else
        echo "Error: plugins/exploit_suggester.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_aircrack() {
    clear
    echo "$BANNER_AIRCRACK"
    echo ""
    if ! command -v aircrack-ng &> /dev/null; then
        echo "Error: aircrack-ng is not installed."
        read -rp "Press Enter to continue..."
        return
    fi
    read -rp "Enter Target Cap File: " CAPFILE
    [ -z "$CAPFILE" ] && return
    echo ""
    if [ -f "$CAPFILE" ]; then
        aircrack-ng "$CAPFILE"
    else
        echo "Error: $CAPFILE not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_satellite() {
    clear
    echo "$BANNER_SATELLITE"
    echo ""
    read -rp "Enter Target Coordinates/Area: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/satellite_recon.py" ]; then
        python3 plugins/satellite_recon.py "$TARGET"
    else
        echo "Error: plugins/satellite_recon.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_proxy() {
    clear
    echo "$BANNER_PROXY"
    echo ""
    if [ -f "plugins/proxy_engine.py" ]; then
        python3 plugins/proxy_engine.py
    else
        echo "Error: plugins/proxy_engine.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_stegano() {
    clear
    echo "$BANNER_STEGANO"
    echo ""
    read -rp "Enter Image Path: " IMG
    [ -z "$IMG" ] && return
    echo ""
    if [ -f "plugins/stegano.py" ]; then
        python3 plugins/stegano.py "$IMG"
    else
        echo "Error: plugins/stegano.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_cupp() {
    clear
    echo "$BANNER_CUPP"
    echo ""
    if [ -f "plugins/cupp/cupp.py" ]; then
        python3 plugins/cupp/cupp.py -i
    else
        echo "Error: plugins/cupp/cupp.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

run_sms_spoofer() {
    clear
    echo "$BANNER_SMSSPOOFER"
    echo ""
    read -rp "Enter Target Phone Number: " TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "plugins/sms_spoofer.py" ]; then
        python3 plugins/sms_spoofer.py "$TARGET"
    else
        echo "Error: plugins/sms_spoofer.py not found!"
    fi
    read -rp "Press Enter to continue..."
}

# ==================== MAIN EXECUTION LOOP ====================
while true; do
    show_menu
    read -rp "Select an option [1-20]: " CHOICE
    case "$CHOICE" in
        1)  run_nmap ;;
        2)  run_wireshark ;;
        3)  run_nslookup ;;
        4)  run_tcp_scanner ;;
        5)  run_subdomain_enum ;;
        6)  run_sherlock ;;
        7)  run_starhunt ;;
        8)  run_breach ;;
        9)  run_email ;;
        10) run_starstrike ;;
        11) run_custom_raw ;;
        12) run_meteor ;;
        13) run_exploit ;;
        14) run_aircrack ;;
        15) run_satellite ;;
        16) run_proxy ;;
        17) run_stegano ;;
        18) run_cupp ;;
        19) run_sms_spoofer ;;
        20) echo "Exiting..."; exit 0 ;;
        *)  echo "Invalid option!"; sleep 1 ;;
    esac
done
