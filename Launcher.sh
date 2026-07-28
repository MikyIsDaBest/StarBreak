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
    echo "  [12] Exit"
    echo "================================================================="
}

# ==================== FUNCTIONS ====================
run_nmap() {
    clear
    echo "$BANNER_NMAP"
    echo ""
    if ! command -v nmap &> /dev/null; then
        echo "Error: Nmap is not installed on this system."
        echo "Install it via your package manager (e.g., sudo apt install nmap)."
        read -rp "Press Enter to continue..."
        return
    fi

    read -rp "Enter Target IP/Subnet (e.g. 192.168.1.1): " NMAP_TARGET
    if [ -z "$NMAP_TARGET" ]; then return; fi

    read -rp "Enter Scan Flags (default -F for fast scan): " NMAP_FLAGS
    NMAP_FLAGS="${NMAP_FLAGS:--F}"

    echo ""
    echo "Executing: nmap $NMAP_FLAGS $NMAP_TARGET"
    echo "---------------------------------------------------"
    nmap $NMAP_FLAGS "$NMAP_TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_wireshark() {
    clear
    echo "$BANNER_WIRESHARK"
    echo ""
    if command -v wireshark &> /dev/null; then
        echo "Launching Wireshark..."
        wireshark &
        sleep 2
    else
        echo "Error: Wireshark is not installed on this system."
        echo "Install it via your package manager (e.g., sudo apt install wireshark)."
        read -rp "Press Enter to continue..."
    fi
}

run_nslookup() {
    clear
    echo "$BANNER_NSLOOKUP"
    echo ""
    read -rp "Enter Domain or IP Address to query: " NS_TARGET
    if [ -z "$NS_TARGET" ]; then return; fi

    echo ""
    echo "Executing: nslookup $NS_TARGET"
    echo "---------------------------------------------------"
    nslookup "$NS_TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_starstrike() {
    clear
    echo "$BANNER_STARSTRIKE"
    echo ""

    read -rp "[1/4] Enter Victim Target IP (e.g. 192.168.0.1): " VICTIM
    while [ -z "$VICTIM" ]; do
        read -rp "[1/4] Target required: " VICTIM
    done

    read -rp "[2/4] Enter Number of Threads (default 50): " THREADS
    THREADS="${THREADS:-50}"

    read -rp "[3/4] Enter Payload Size in bytes (default 65455): " PAYLOAD
    PAYLOAD="${PAYLOAD:-65455}"

    read -rp "[4/4] Enter Type (e.g. tcp, udp, icmp. http): " TYPE
    TYPE="${TYPE:-tcp}"

    clear
    echo "$BANNER_STARSTRIKE"
    echo ""
    echo "Executing command:"
    echo "python3 plugins/starstrike.py --threads${THREADS} --payloadsize${PAYLOAD} --type${TYPE} --victim${VICTIM}"
    echo "---------------------------------------------------"
    echo ""

    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    elif [ -f "plugins/starbreak.py" ]; then
        python3 plugins/starbreak.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    else
        echo "Error: Could not find starstrike.py in plugins/ folder."
    fi

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_custom_raw() {
    clear
    echo "$BANNER_STARSTRIKE"
    echo ""
    echo "Type the full argument string to pass directly to starstrike.py"
    echo "Example: --threads50 --payloadsize65455 --typetcp --victim192.168.0.1 --noprint(doesn't print the output) --unlockport(attacks all ports)"
    echo "---------------------------------------------------"
    read -rp "Enter flags > " RAW_ARGS

    echo ""
    echo "Executing: python3 plugins/starstrike.py $RAW_ARGS"
    echo "---------------------------------------------------"
    echo ""

    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py $RAW_ARGS
    else
        echo "Error: Could not find plugins/starstrike.py"
    fi

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_cupp() {
    clear
    echo "$BANNER_CUPP"
    echo ""

    if [ -f "plugins/cupp/cupp.py" ]; then
        python3 plugins/cupp/cupp.py -i
    elif [ -f "plugins/cupp.py" ]; then
        python3 plugins/cupp.py -i
    elif command -v cupp &> /dev/null; then
        cupp -i
    else
        echo "CUPP not detected in plugins/ directory."
        read -rp "Would you like to clone CUPP into plugins/ now? (y/n): " INSTALL_CUPP
        if [[ "$INSTALL_CUPP" =~ ^[Yy]$ ]]; then
            git clone https://github.com/Mebus/cupp.git plugins/cupp
            if [ -f "plugins/cupp/cupp.py" ]; then
                echo "CUPP downloaded successfully! Starting interactive setup..."
                python3 plugins/cupp/cupp.py -i
            fi
        fi
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_sherlock() {
    clear
    echo "$BANNER_SHERLOCK"
    echo ""

    read -rp "Enter Username to search (e.g. johndoe): " TARGET_USER
    if [ -z "$TARGET_USER" ]; then return; fi

    echo ""
    echo "Searching for target: $TARGET_USER"
    echo "---------------------------------------------------"

    if command -v sherlock &> /dev/null; then
        sherlock "$TARGET_USER"
    elif [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock/sherlock.py "$TARGET_USER"
    elif [ -f "plugins/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock.py "$TARGET_USER"
    else
        echo "Sherlock is not installed globally or in plugins/ directory."
        read -rp "Would you like to clone Sherlock into plugins/ now? (y/n): " INSTALL_SHERLOCK
        if [[ "$INSTALL_SHERLOCK" =~ ^[Yy]$ ]]; then
            git clone https://github.com/sherlock-project/sherlock.git plugins/sherlock
            if [ -f "plugins/sherlock/requirements.txt" ]; then
                echo "Installing Python dependencies for Sherlock..."
                python3 -m pip install -r plugins/sherlock/requirements.txt
            fi
            if [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then
                echo "Sherlock downloaded! Executing search..."
                python3 plugins/sherlock/sherlock/sherlock.py "$TARGET_USER"
            fi
        fi
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_tcp_scanner() {
    clear
    echo "$BANNER_TCPSCANNER"
    echo ""

    read -rp "Enter Target IP / Hostname: " SCAN_TARGET
    if [ -z "$SCAN_TARGET" ]; then return; fi

    read -rp "Enter Start Port (default 1): " START_PORT
    START_PORT="${START_PORT:-1}"

    read -rp "Enter End Port (default 1024): " END_PORT
    END_PORT="${END_PORT:-1024}"

    echo ""
    echo "---------------------------------------------------"

    if [ -f "plugins/tcp_scanner.py" ]; then
        python3 plugins/tcp_scanner.py --target "$SCAN_TARGET" --start_port "$START_PORT" --end_port "$END_PORT"
    else
        echo "Error: Could not find plugins/tcp_scanner.py"
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_aircrack() {
    clear
    echo "$BANNER_AIRCRACK"
    echo ""

    if ! command -v aircrack-ng &> /dev/null; then
        echo "Error: aircrack-ng is not installed on this system."
        echo "Install it via your package manager (e.g., sudo apt install aircrack-ng)."
        read -rp "Press Enter to continue..."
        return
    fi

    read -rp "Enter target .cap / .pcap capture file path: " CAP_FILE
    if [ -z "$CAP_FILE" ]; then return; fi

    read -rp "Enter wordlist file path (optional, press Enter to skip): " WORDLIST

    echo ""
    echo "Executing Aircrack-ng..."
    echo "---------------------------------------------------"
    if [ -n "$WORDLIST" ]; then
        aircrack-ng -w "$WORDLIST" "$CAP_FILE"
    else
        aircrack-ng "$CAP_FILE"
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_sms_spoofer() {
    clear
    echo "$BANNER_SMSSPOOFER"
    echo ""

    read -rp "Enter Target Phone Number (e.g., +1234567890): " SMS_TARGET
    if [ -z "$SMS_TARGET" ]; then return; fi

    read -rp "Enter Spoofed Sender ID (e.g., +19998887777): " SMS_SPOOF
    if [ -z "$SMS_SPOOF" ]; then 
        SMS_SPOOF="+00000000000"
    fi

    read -rp "Enter Message Content: " SMS_MSG
    if [ -z "$SMS_MSG" ]; then
        SMS_MSG="Hello from CATShadow Spoofer!"
    fi

    read -rp "Enter Number of Messages (default 10): " SMS_COUNT
    SMS_COUNT="${SMS_COUNT:-10}"

    read -rp "Enter Threads (default 5): " SMS_THREADS
    SMS_THREADS="${SMS_THREADS:-5}"

    clear
    echo "$BANNER_SMSSPOOFER"
    echo ""
    echo "Target:  $SMS_TARGET"
    echo "Spoof:   $SMS_SPOOF"
    echo "Message: ${SMS_MSG:0:50}${SMS_MSG:50:+"..."}"
    echo "Count:   $SMS_COUNT"
    echo "Threads: $SMS_THREADS"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/sms_spoofer.py" ]; then
        echo "Error: plugins/sms_spoofer.py not found!"
        echo "Please ensure the SMS spoofer script is in the plugins/ directory."
        read -rp "Press Enter to continue..."
        return
    fi

    python3 plugins/sms_spoofer.py \
        --target "$SMS_TARGET" \
        --spoof "$SMS_SPOOF" \
        --msg "$SMS_MSG" \
        --count "$SMS_COUNT" \
        --threads "$SMS_THREADS"

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_starhunt() {
    clear
    echo "$BANNER_STARHUNT"
    echo ""

    read -rp "Enter Username to search: " TARGET_USER
    if [ -z "$TARGET_USER" ]; then return; fi

    read -rp "Enter Threads (default 20): " THREADS
    THREADS="${THREADS:-20}"

    read -rp "Enter Timeout (default 10s): " TIMEOUT
    TIMEOUT="${TIMEOUT:-10}"

    clear
    echo "$BANNER_STARHUNT"
    echo ""
    echo "Username: $TARGET_USER"
    echo "Threads:  $THREADS"
    echo "Timeout:  $TIMEOUT"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/starhunt.py" ]; then
        echo "Error: plugins/starhunt.py not found!"
        echo "Please ensure the StarHunt script is in the plugins/ directory."
        read -rp "Press Enter to continue..."
        return
    fi

    python3 plugins/starhunt.py "$TARGET_USER" --threads "$THREADS" --timeout "$TIMEOUT"

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

# ==================== MAIN LOOP ====================
while true; do
    show_menu
    read -rp "Select a tool [1-12]: " CHOICE
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
        12) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid selection, please try again."; sleep 1 ;;
    esac
done
