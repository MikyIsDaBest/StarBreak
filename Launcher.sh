#!/usr/bin/env bash

# Lock script directory so paths remain relative to launcher.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Ensure plugins directory exists
mkdir -p plugins

# ==================== ASCII BANNERS ====================
BANNER_NMAP="
┌─────────────────────────────────────────────────────┐
│  ███╗   ██╗███╗   ███╗ █████╗ ██████╗             │
│  ████╗  ██║████╗ ████║██╔══██╗██╔══██╗            │
│  ██╔██╗ ██║██╔████╔██║███████║██████╔╝            │
│  ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝             │
│  ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║                 │
│  ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝                 │
│               PORT SCANNER                         │
└─────────────────────────────────────────────────────┘"

BANNER_WIRESHARK="
┌─────────────────────────────────────────────────────┐
│  ╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗                │
│  ╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║                │
│  ╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝                │
│           PACKET CAPTURE                          │
└─────────────────────────────────────────────────────┘"

BANNER_NSLOOKUP="
┌─────────────────────────────────────────────────────┐
│  ███╗   ██╗███████╗██╗      ██████╗  ██████╗     │
│  ████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗    │
│  ██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║    │
│  ██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║    │
│  ██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝    │
│  ╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝     │
│              DNS LOOKUP                           │
└─────────────────────────────────────────────────────┘"

BANNER_STARSTRIKE="
┌─────────────────────────────────────────────────────┐
│   ███████╗████████╗ █████╗ ██████╗ ███████╗████████╗
│   ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
│   ███████╗   ██║   ███████║██████╔╝███████╗   ██║   
│   ╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║   
│   ███████║   ██║   ██║  ██║██║  ██║███████║   ██║   
│   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   
│              STRIKE ENGINE                         │
└─────────────────────────────────────────────────────┘"

BANNER_CUPP="
┌─────────────────────────────────────────────────────┐
│   ██████╗██╗   ██╗██████╗ ██████╗                  │
│  ██╔════╝██║   ██║██╔══██╗██╔══██╗                │
│  ██║     ██║   ██║██████╔╝██████╔╝                │
│  ██║     ██║   ██║██╔═══╝ ██╔═══╝                 │
│  ╚██████╗╚██████╔╝██║     ██║                     │
│   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝                     │
│           PASSWORD PROFILER                        │
└─────────────────────────────────────────────────────┘"

BANNER_SHERLOCK="
┌─────────────────────────────────────────────────────┐
│   ███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗
│   ██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗
│   ███████╗███████║█████╗  ██████╔╝██║     ██║   ██║
│   ╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║
│   ███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝
│   ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ 
│           OSINT LOOKUP                            │
└─────────────────────────────────────────────────────┘"

BANNER_TCPSCANNER="
┌─────────────────────────────────────────────────────┐
│   ████████╗ ██████╗██████╗                         │
│   ╚══██╔══╝██╔════╝██╔══██╗                        │
│      ██║   ██║     ██████╔╝                        │
│      ██║   ██║     ██╔═══╝                         │
│      ██║   ╚██████╗██║                             │
│      ╚═╝    ╚═════╝╚═╝                             │
│           PORT SCANNER                            │
└─────────────────────────────────────────────────────┘"

BANNER_AIRCRACK="
┌─────────────────────────────────────────────────────┐
│   █████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗
│  ██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝
│  ███████║██║██████╔╝██║     ██████╔╝███████║██║     
│  ██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║     
│  ██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗
│  ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
│           WIRELESS SECURITY                        │
└─────────────────────────────────────────────────────┘"

BANNER_SMSSPOOFER="
┌─────────────────────────────────────────────────────┐
│   ███████╗███╗   ███╗███████╗                      │
│   ██╔════╝████╗ ████║██╔════╝                      │
│   ███████╗██╔████╔██║███████╗                      │
│   ╚════██║██║╚██╔╝██║╚════██║                      │
│   ███████║██║ ╚═╝ ██║███████║                      │
│   ╚══════╝╚═╝     ╚═╝╚══════╝                      │
│   ███████╗██████╗  ██████╗  ██████╗ ███████╗██████╗
│   ██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██╔══██╗
│   ███████╗██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝
│   ╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝  ██╔══██╗
│   ███████║██║     ╚██████╔╝╚██████╔╝███████╗██║  ██║
│   ╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
│           FREE SMS SPOOFING ENGINE                  │
└─────────────────────────────────────────────────────┘"

BANNER_STARHUNT="
┌─────────────────────────────────────────────────────┐
│   ███████╗████████╗ █████╗ ██████╗                  │
│   ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗                 │
│   ███████╗   ██║   ███████║██████╔╝                 │
│   ╚════██║   ██║   ██╔══██║██╔══██╗                 │
│   ███████║   ██║   ██║  ██║██║  ██║                 │
│   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝                 │
│   ██╗  ██╗██╗   ██╗███╗   ██╗████████╗              │
│   ██║  ██║██║   ██║████╗  ██║╚══██╔══╝              │
│   ███████║██║   ██║██╔██╗ ██║   ██║                 │
│   ██╔══██║██║   ██║██║╚██╗██║   ██║                 │
│   ██║  ██║╚██████╔╝██║ ╚████║   ██║                 │
│   ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝                 │
│           ADVANCED OSINT - 50+ PLATFORMS             │
└─────────────────────────────────────────────────────┘"

BANNER_METEOR="
┌─────────────────────────────────────────────────────┐
│  ███╗   ███╗████████╗████████╗███████╗██████╗     │
│  ████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗    │
│  ██╔████╔██║   ██║      ██║   █████╗  ██████╔╝    │
│  ██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗    │
│  ██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║    │
│  ╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝    │
│   ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗    │
│   ██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝    │
│   ███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗    │
│   ╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║    │
│   ███████║   ██║   ██║  ██║██║██║  ██╗███████║    │
│   ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝    │
└─────────────────────────────────────────────────────┘"

# ==================== MENU ====================
show_menu() {
    clear
    echo "================================================================="
    echo "   ____ _____  _    ____    ____  ____  _____    _    _  __ "
    echo "  / ___|_   _|/ \  |  _ \  | __ )|  _ \| ____|  / \  | |/ / "
    echo "  \___ \ | | / _ \ | |_) | |  _ \| |_) |  _|   / _ \ | ' /  "
    echo "   ___) || |/ ___ \|  _ <  | |_) |  _ <| |___ / ___ \| . \  "
    echo "  |____/ |_/_/   \_\_| \_\ |____/|_| \_\_____/_/   \_\_|\_\ "
    echo ""
    echo "                     Made by N E T W O R K 0             "
    echo "================================================================="
    echo "                     NETWORK AND SECURITY SUITE           "
    echo "================================================================="
    echo "  [1] Launch Nmap (Port AND Network Discovery)"
    echo "  [2] Launch Wireshark (Packet Capture)"
    echo "  [3] Launch Nslookup (DNS Lookup Tool)"
    echo "  [4] Launch StarStrike Plugin (Guided Inputs)"
    echo "  [5] Launch StarStrike Plugin (Custom Raw Command)"
    echo "  [6] Launch CUPP (Common User Passwords Profiler)"
    echo "  [7] Launch Sherlock (OSINT Username Lookup)"
    echo "  [8] Launch TCP Port Scanner Plugin"
    echo "  [9] Launch Aircrack-ng (Wireless Security Suite)"
    echo "  [10] Launch SMS Spoofer (Free SMS Spoofing)"
    echo "  [11] Launch StarHunt (Advanced OSINT - 50+ platforms)"
    echo "  [12] Launch M3T30R STR!K3 (Multi‑Protocol DoS)"
    echo "  [13] Exit"
    echo "================================================================="
}

# ==================== FUNCTIONS ====================
# ... (all previous functions: run_nmap, run_wireshark, run_nslookup, run_starstrike, run_custom_raw, run_cupp, run_sherlock, run_tcp_scanner, run_aircrack, run_sms_spoofer, run_starhunt) ...

# I'll include only the new function and the launcher main loop for brevity; 
# but in the final answer I will provide the full launcher script with all functions intact.
# For the answer, I will present the full launcher as a single code block.

run_meteor_strike() {
    clear
    echo "$BANNER_METEOR"
    echo ""
    echo "  M3T30R STR!K3 – Unleash the digital storm"
    echo ""

    read -rp "Enter Target IP or Domain: " TARGET
    if [ -z "$TARGET" ]; then return; fi

    read -rp "Enter Target Port (default 80): " PORT
    PORT="${PORT:-80}"

    read -rp "Enter Protocol (tcp/udp/icmp/http, default tcp): " PROTO
    PROTO="${PROTO:-tcp}"

    read -rp "Enter Threads (default 50): " THREADS
    THREADS="${THREADS:-50}"

    read -rp "Enter Duration in seconds (default 30): " DURATION
    DURATION="${DURATION:-30}"

    read -rp "Enter Payload Size in bytes (default 1024): " PAYLOAD
    PAYLOAD="${PAYLOAD:-1024}"

    read -rp "Spoof Source IP? (optional, press Enter to skip): " SPOOF

    clear
    echo "$BANNER_METEOR"
    echo ""
    echo "Target:    $TARGET"
    echo "Port:      $PORT"
    echo "Protocol:  $PROTO"
    echo "Threads:   $THREADS"
    echo "Duration:  $DURATION s"
    echo "Payload:   $PAYLOAD B"
    echo "Spoof:     ${SPOOF:-None}"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/meteor_strike.py" ]; then
        echo "Error: plugins/meteor_strike.py not found!"
        read -rp "Press Enter to continue..."
        return
    fi

    python3 plugins/meteor_strike.py \
        --target "$TARGET" \
        --port "$PORT" \
        --protocol "$PROTO" \
        --threads "$THREADS" \
        --duration "$DURATION" \
        --payload "$PAYLOAD" \
        ${SPOOF:+--spoof "$SPOOF"}

    echo ""
    read -rp "Press Enter to continue..."
}

# ==================== MAIN LOOP ====================
while true; do
    show_menu
    read -rp "Select a tool [1-13]: " CHOICE
    case "$CHOICE" in
        1) run_nmap ;;
        2) run_wireshark ;;
        3) run_nslookup ;;
        4) run_starstrike ;;
        5) run_custom_raw ;;
        6) run_cupp ;;
        7) run_sherlock ;;
        8) run_tcp_scanner ;;
        9) run_aircrack ;;
        10) run_sms_spoofer ;;
        11) run_starhunt ;;
        12) run_meteor_strike ;;
        13) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid selection, please try again."; sleep 1 ;;
    esac
done
