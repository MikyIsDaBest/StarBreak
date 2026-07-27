#!/usr/bin/env bash

# Lock script directory so paths remain relative to launcher.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Ensure plugins directory exists
mkdir -p plugins

show_menu() {
    clear
    echo "==================================================="
    echo "                     STARBREAK                     "
    echo "              Made by N E T W O R K 0              "
    echo "==================================================="
    echo "              NETWORK AND SECURITY SUITE           "
    echo "==================================================="
    echo "  [1] Launch Nmap (Port AND Network Discovery)"
    echo "  [2] Launch Wireshark (Packet Capture)"
    echo "  [3] Launch Nslookup (DNS Lookup Tool)"
    echo "  [4] Launch StarStrike Plugin (Guided Inputs)"
    echo "  [5] Launch StarStrike Plugin (Custom Raw Command)"
    echo "  [6] Exit"
    echo "==================================================="
}

run_nmap() {
    clear
    echo "==================================================="
    echo "                    MODULE: NMAP                   "
    echo "==================================================="
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
    echo "==================================================="
    echo "                 MODULE: WIRESHARK                 "
    echo "==================================================="
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
    echo "==================================================="
    echo "                   MODULE: NSLOOKUP                "
    echo "==================================================="
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
    echo "==================================================="
    echo "               STARSTRIKE PLUGIN ENGINE            "
    echo "==================================================="

    read -rp "[1/4] Enter Victim Target IP (e.g. 192.168.0.1): " VICTIM
    while [ -z "$VICTIM" ]; do
        read -rp "[1/4] Target required: " VICTIM
    done

    read -rp "[2/4] Enter Number of Threads (default 50): " THREADS
    THREADS="${THREADS:-50}"

    read -rp "[3/4] Enter Payload Size in bytes (default 65455): " PAYLOAD
    PAYLOAD="${PAYLOAD:-65455}"

    read -rp "[4/4] Enter Type (e.g. tcp, udp, icmp): " TYPE
    TYPE="${TYPE:-tcp}"

    clear
    echo "==================================================="
    echo "               LAUNCHING STARSTRIKE                "
    echo "==================================================="
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
    echo "==================================================="
    echo "            STARSTRIKE RAW COMMAND LAUNCHER        "
    echo "==================================================="
    echo "Type the full argument string to pass directly to starstrike.py"
    echo "Example: --threads50 --payloadsize65455 --typetcp --victim192.168.0.1"
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

while true; do
    show_menu
    read -rp "Select a tool [1-6]: " CHOICE
    case "$CHOICE" in
        1) run_nmap ;;
        2) run_wireshark ;;
        3) run_nslookup ;;
        4) run_starstrike ;;
        5) run_custom_raw ;;
        6) echo "Goodbye!"; exit 0 ;;
        *) echo "Invalid selection, please try again."; sleep 1 ;;
    esac
done
