#!/usr/bin/env bash

# Lock script directory so paths remain relative to launcher.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Ensure plugins directory exists
mkdir -p plugins

# ==================== COLOR DEFINITIONS ====================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ==================== ASCII BANNERS ====================
BANNER_NMAP="
${CYAN}┌─────────────────────────────────────────────────────┐${NC}
${CYAN}│${NC}  ${BOLD}███╗   ██╗███╗   ███╗ █████╗ ██████╗${NC}             ${CYAN}│${NC}
${CYAN}│${NC}  ${BOLD}████╗  ██║████╗ ████║██╔══██╗██╔══██╗${NC}            ${CYAN}│${NC}
${CYAN}│${NC}  ${BOLD}██╔██╗ ██║██╔████╔██║███████║██████╔╝${NC}            ${CYAN}│${NC}
${CYAN}│${NC}  ${BOLD}██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝${NC}             ${CYAN}│${NC}
${CYAN}│${NC}  ${BOLD}██║ ╚████║██║ ╚═╝ ██║██║  ██║██║${NC}                 ${CYAN}│${NC}
${CYAN}│${NC}  ${BOLD}╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝${NC}                 ${CYAN}│${NC}
${CYAN}│${NC}               ${BOLD}PORT SCANNER${NC}                         ${CYAN}│${NC}
${CYAN}└─────────────────────────────────────────────────────┘${NC}"

BANNER_WIRESHARK="
${YELLOW}┌─────────────────────────────────────────────────────┐${NC}
${YELLOW}│${NC}  ${BOLD}╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗${NC}                ${YELLOW}│${NC}
${YELLOW}│${NC}  ${BOLD}╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║${NC}                ${YELLOW}│${NC}
${YELLOW}│${NC}  ${BOLD}╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝${NC}                ${YELLOW}│${NC}
${YELLOW}│${NC}           ${BOLD}PACKET CAPTURE${NC}                          ${YELLOW}│${NC}
${YELLOW}└─────────────────────────────────────────────────────┘${NC}"

BANNER_NSLOOKUP="
${BLUE}┌─────────────────────────────────────────────────────┐${NC}
${BLUE}│${NC}  ${BOLD}███╗   ██╗███████╗██╗      ██████╗  ██████╗${NC}     ${BLUE}│${NC}
${BLUE}│${NC}  ${BOLD}████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗${NC}    ${BLUE}│${NC}
${BLUE}│${NC}  ${BOLD}██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║${NC}    ${BLUE}│${NC}
${BLUE}│${NC}  ${BOLD}██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║${NC}    ${BLUE}│${NC}
${BLUE}│${NC}  ${BOLD}██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝${NC}    ${BLUE}│${NC}
${BLUE}│${NC}  ${BOLD}╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝${NC}     ${BLUE}│${NC}
${BLUE}│${NC}              ${BOLD}DNS LOOKUP${NC}                           ${BLUE}│${NC}
${BLUE}└─────────────────────────────────────────────────────┘${NC}"

BANNER_STARSTRIKE="
${RED}┌─────────────────────────────────────────────────────┐${NC}
${RED}│${NC}   ${BOLD}███████╗████████╗ █████╗ ██████╗ ███████╗████████╗${NC}
${RED}│${NC}   ${BOLD}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝${NC}
${RED}│${NC}   ${BOLD}███████╗   ██║   ███████║██████╔╝███████╗   ██║${NC}   ${RED}│${NC}
${RED}│${NC}   ${BOLD}╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║${NC}   ${RED}│${NC}
${RED}│${NC}   ${BOLD}███████║   ██║   ██║  ██║██║  ██║███████║   ██║${NC}   ${RED}│${NC}
${RED}│${NC}   ${BOLD}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝${NC}   ${RED}│${NC}
${RED}│${NC}              ${BOLD}STRIKE ENGINE${NC}                         ${RED}│${NC}
${RED}└─────────────────────────────────────────────────────┘${NC}"

BANNER_CUPP="
${MAGENTA}┌─────────────────────────────────────────────────────┐${NC}
${MAGENTA}│${NC}   ${BOLD}██████╗██╗   ██╗██████╗ ██████╗${NC}                  ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${BOLD}██╔════╝██║   ██║██╔══██╗██╔══██╗${NC}                ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${BOLD}██║     ██║   ██║██████╔╝██████╔╝${NC}                ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${BOLD}██║     ██║   ██║██╔═══╝ ██╔═══╝${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${BOLD}╚██████╗╚██████╔╝██║     ██║${NC}                     ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}╚═════╝ ╚═════╝ ╚═╝     ╚═╝${NC}                     ${MAGENTA}│${NC}
${MAGENTA}│${NC}           ${BOLD}PASSWORD PROFILER${NC}                        ${MAGENTA}│${NC}
${MAGENTA}└─────────────────────────────────────────────────────┘${NC}"

BANNER_SHERLOCK="
${GREEN}┌─────────────────────────────────────────────────────┐${NC}
${GREEN}│${NC}   ${BOLD}███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗${NC}
${GREEN}│${NC}   ${BOLD}██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗${NC}
${GREEN}│${NC}   ${BOLD}███████╗███████║█████╗  ██████╔╝██║     ██║   ██║${NC}
${GREEN}│${NC}   ${BOLD}╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║${NC}
${GREEN}│${NC}   ${BOLD}███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝${NC}
${GREEN}│${NC}   ${BOLD}╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝${NC} 
${GREEN}│${NC}           ${BOLD}OSINT LOOKUP${NC}                            ${GREEN}│${NC}
${GREEN}└─────────────────────────────────────────────────────┘${NC}"

BANNER_TCPSCANNER="
${CYAN}┌─────────────────────────────────────────────────────┐${NC}
${CYAN}│${NC}   ${BOLD}████████╗ ██████╗██████╗${NC}                         ${CYAN}│${NC}
${CYAN}│${NC}   ${BOLD}╚══██╔══╝██╔════╝██╔══██╗${NC}                        ${CYAN}│${NC}
${CYAN}│${NC}      ${BOLD}██║   ██║     ██████╔╝${NC}                        ${CYAN}│${NC}
${CYAN}│${NC}      ${BOLD}██║   ██║     ██╔═══╝${NC}                         ${CYAN}│${NC}
${CYAN}│${NC}      ${BOLD}██║   ╚██████╗██║${NC}                             ${CYAN}│${NC}
${CYAN}│${NC}      ${BOLD}╚═╝    ╚═════╝╚═╝${NC}                             ${CYAN}│${NC}
${CYAN}│${NC}           ${BOLD}PORT SCANNER${NC}                            ${CYAN}│${NC}
${CYAN}└─────────────────────────────────────────────────────┘${NC}"

BANNER_AIRCRACK="
${RED}┌─────────────────────────────────────────────────────┐${NC}
${RED}│${NC}   ${BOLD}█████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗${NC}
${RED}│${NC}  ${BOLD}██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝${NC}
${RED}│${NC}  ${BOLD}███████║██║██████╔╝██║     ██████╔╝███████║██║${NC}     
${RED}│${NC}  ${BOLD}██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║${NC}     
${RED}│${NC}  ${BOLD}██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗${NC}
${RED}│${NC}  ${BOLD}╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝${NC}
${RED}│${NC}           ${BOLD}WIRELESS SECURITY${NC}                        ${RED}│${NC}
${RED}└─────────────────────────────────────────────────────┘${NC}"

BANNER_SMSSPOOFER="
${YELLOW}┌─────────────────────────────────────────────────────┐${NC}
${YELLOW}│${NC}   ${BOLD}███████╗███╗   ███╗███████╗${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}██╔════╝████╗ ████║██╔════╝${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}███████╗██╔████╔██║███████╗${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}╚════██║██║╚██╔╝██║╚════██║${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}███████║██║ ╚═╝ ██║███████║${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}╚══════╝╚═╝     ╚═╝╚══════╝${NC}                      ${YELLOW}│${NC}
${YELLOW}│${NC}   ${BOLD}███████╗██████╗  ██████╗  ██████╗ ███████╗██████╗${NC}
${YELLOW}│${NC}   ${BOLD}██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██╔══██╗${NC}
${YELLOW}│${NC}   ${BOLD}███████╗██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝${NC}
${YELLOW}│${NC}   ${BOLD}╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝  ██╔══██╗${NC}
${YELLOW}│${NC}   ${BOLD}███████║██║     ╚██████╔╝╚██████╔╝███████╗██║  ██║${NC}
${YELLOW}│${NC}   ${BOLD}╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝${NC}
${YELLOW}│${NC}           ${BOLD}FREE SMS SPOOFING ENGINE${NC}                  ${YELLOW}│${NC}
${YELLOW}└─────────────────────────────────────────────────────┘${NC}"

BANNER_STARHUNT="
${MAGENTA}┌─────────────────────────────────────────────────────┐${NC}
${MAGENTA}│${NC}   ${BOLD}███████╗████████╗ █████╗ ██████╗${NC}                  ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}███████╗   ██║   ███████║██████╔╝${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}╚════██║   ██║   ██╔══██║██╔══██╗${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}███████║   ██║   ██║  ██║██║  ██║${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}██╗  ██╗██╗   ██╗███╗   ██╗████████╗${NC}              ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}██║  ██║██║   ██║████╗  ██║╚══██╔══╝${NC}              ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}███████║██║   ██║██╔██╗ ██║   ██║${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}██╔══██║██║   ██║██║╚██╗██║   ██║${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}██║  ██║╚██████╔╝██║ ╚████║   ██║${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}   ${BOLD}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝${NC}                 ${MAGENTA}│${NC}
${MAGENTA}│${NC}           ${BOLD}ADVANCED OSINT - 50+ PLATFORMS${NC}             ${MAGENTA}│${NC}
${MAGENTA}└─────────────────────────────────────────────────────┘${NC}"

BANNER_METEOR="
${RED}┌─────────────────────────────────────────────────────┐${NC}
${RED}│${NC}  ${BOLD}███╗   ███╗████████╗████████╗███████╗██████╗${NC}     ${RED}│${NC}
${RED}│${NC}  ${BOLD}████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗${NC}    ${RED}│${NC}
${RED}│${NC}  ${BOLD}██╔████╔██║   ██║      ██║   █████╗  ██████╔╝${NC}    ${RED}│${NC}
${RED}│${NC}  ${BOLD}██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗${NC}    ${RED}│${NC}
${RED}│${NC}  ${BOLD}██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║${NC}    ${RED}│${NC}
${RED}│${NC}  ${BOLD}╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}███████╗████████╗██████╗ ██╗██╗  ██╗███████╗${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}███████║   ██║   ██║  ██║██║██║  ██╗███████║${NC}    ${RED}│${NC}
${RED}│${NC}   ${BOLD}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝${NC}    ${RED}│${NC}
${RED}│${NC}           ${BOLD}MULTI‑PROTOCOL DOS ENGINE${NC}              ${RED}│${NC}
${RED}└─────────────────────────────────────────────────────┘${NC}"

# ==================== MENU ====================
show_menu() {
    clear
    echo -e "${CYAN}=================================================================${NC}"
    echo -e "${GREEN}   ____ _____  _    ____    ____  ____  _____    _    _  __ ${NC}"
    echo -e "${GREEN}  / ___|_   _|/ \  |  _ \  | __ )|  _ \| ____|  / \  | |/ / ${NC}"
    echo -e "${GREEN}  \___ \ | | / _ \ | |_) | |  _ \| |_) |  _|   / _ \ | ' /  ${NC}"
    echo -e "${GREEN}   ___) || |/ ___ \|  _ <  | |_) |  _ <| |___ / ___ \| . \  ${NC}"
    echo -e "${GREEN}  |____/ |_/_/   \_\_| \_\ |____/|_| \_\_____/_/   \_\_|\_\ ${NC}"
    echo ""
    echo -e "${YELLOW}                     Made by N E T W O R K 0             ${NC}"
    echo -e "${CYAN}=================================================================${NC}"
    echo -e "${CYAN}                     NETWORK AND SECURITY SUITE           ${NC}"
    echo -e "${CYAN}=================================================================${NC}"
    echo -e "${WHITE}  [${GREEN}1${WHITE}]${GREEN} Launch Nmap (Port AND Network Discovery)${NC}"
    echo -e "${WHITE}  [${GREEN}2${WHITE}]${YELLOW} Launch Wireshark (Packet Capture)${NC}"
    echo -e "${WHITE}  [${GREEN}3${WHITE}]${BLUE} Launch Nslookup (DNS Lookup Tool)${NC}"
    echo -e "${WHITE}  [${GREEN}4${WHITE}]${RED} Launch StarStrike Plugin (Guided Inputs)${NC}"
    echo -e "${WHITE}  [${GREEN}5${WHITE}]${RED} Launch StarStrike Plugin (Custom Raw Command)${NC}"
    echo -e "${WHITE}  [${GREEN}6${WHITE}]${MAGENTA} Launch CUPP (Common User Passwords Profiler)${NC}"
    echo -e "${WHITE}  [${GREEN}7${WHITE}]${GREEN} Launch Sherlock (OSINT Username Lookup)${NC}"
    echo -e "${WHITE}  [${GREEN}8${WHITE}]${CYAN} Launch TCP Port Scanner Plugin${NC}"
    echo -e "${WHITE}  [${GREEN}9${WHITE}]${RED} Launch Aircrack-ng (Wireless Security Suite)${NC}"
    echo -e "${WHITE}  [${GREEN}10${WHITE}]${YELLOW} Launch SMS Spoofer (Free SMS Spoofing)${NC}"
    echo -e "${WHITE}  [${GREEN}11${WHITE}]${MAGENTA} Launch StarHunt (Advanced OSINT - 50+ platforms)${NC}"
    echo -e "${WHITE}  [${GREEN}12${WHITE}]${RED} Launch M3T30R STR!K3 (Multi‑Protocol DoS)${NC}"
    echo -e "${WHITE}  [${GREEN}13${WHITE}] Exit${NC}"
    echo -e "${CYAN}=================================================================${NC}"
}

# ==================== FUNCTIONS ====================
run_nmap() {
    clear
    echo -e "$BANNER_NMAP"
    echo ""
    if ! command -v nmap &> /dev/null; then
        echo -e "${RED}Error: Nmap is not installed on this system.${NC}"
        echo -e "${YELLOW}Install it via your package manager (e.g., sudo apt install nmap).${NC}"
        read -rp "Press Enter to continue..."
        return
    fi

    read -rp "Enter Target IP/Subnet (e.g. 192.168.1.1): " NMAP_TARGET
    if [ -z "$NMAP_TARGET" ]; then return; fi

    read -rp "Enter Scan Flags (default -F for fast scan): " NMAP_FLAGS
    NMAP_FLAGS="${NMAP_FLAGS:--F}"

    echo ""
    echo -e "${GREEN}Executing: nmap $NMAP_FLAGS $NMAP_TARGET${NC}"
    echo "---------------------------------------------------"
    nmap $NMAP_FLAGS "$NMAP_TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_wireshark() {
    clear
    echo -e "$BANNER_WIRESHARK"
    echo ""
    if command -v wireshark &> /dev/null; then
        echo -e "${GREEN}Launching Wireshark...${NC}"
        wireshark &
        sleep 2
    else
        echo -e "${RED}Error: Wireshark is not installed on this system.${NC}"
        echo -e "${YELLOW}Install it via your package manager (e.g., sudo apt install wireshark).${NC}"
        read -rp "Press Enter to continue..."
    fi
}

run_nslookup() {
    clear
    echo -e "$BANNER_NSLOOKUP"
    echo ""
    read -rp "Enter Domain or IP Address to query: " NS_TARGET
    if [ -z "$NS_TARGET" ]; then return; fi

    echo ""
    echo -e "${GREEN}Executing: nslookup $NS_TARGET${NC}"
    echo "---------------------------------------------------"
    nslookup "$NS_TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_starstrike() {
    clear
    echo -e "$BANNER_STARSTRIKE"
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
    echo -e "$BANNER_STARSTRIKE"
    echo ""
    echo -e "${GREEN}Executing command:${NC}"
    echo "python3 plugins/starstrike.py --threads${THREADS} --payloadsize${PAYLOAD} --type${TYPE} --victim${VICTIM}"
    echo "---------------------------------------------------"
    echo ""

    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    elif [ -f "plugins/starbreak.py" ]; then
        python3 plugins/starbreak.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    else
        echo -e "${RED}Error: Could not find starstrike.py in plugins/ folder.${NC}"
    fi

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_custom_raw() {
    clear
    echo -e "$BANNER_STARSTRIKE"
    echo ""
    echo -e "${YELLOW}Type the full argument string to pass directly to starstrike.py${NC}"
    echo "Example: --threads50 --payloadsize65455 --typetcp --victim192.168.0.1 --noprint(doesn't print the output) --unlockport(attacks all ports)"
    echo "---------------------------------------------------"
    read -rp "Enter flags > " RAW_ARGS

    echo ""
    echo -e "${GREEN}Executing: python3 plugins/starstrike.py $RAW_ARGS${NC}"
    echo "---------------------------------------------------"
    echo ""

    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py $RAW_ARGS
    else
        echo -e "${RED}Error: Could not find plugins/starstrike.py${NC}"
    fi

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_cupp() {
    clear
    echo -e "$BANNER_CUPP"
    echo ""

    if [ -f "plugins/cupp/cupp.py" ]; then
        python3 plugins/cupp/cupp.py -i
    elif [ -f "plugins/cupp.py" ]; then
        python3 plugins/cupp.py -i
    elif command -v cupp &> /dev/null; then
        cupp -i
    else
        echo -e "${YELLOW}CUPP not detected in plugins/ directory.${NC}"
        read -rp "Would you like to clone CUPP into plugins/ now? (y/n): " INSTALL_CUPP
        if [[ "$INSTALL_CUPP" =~ ^[Yy]$ ]]; then
            git clone https://github.com/Mebus/cupp.git plugins/cupp
            if [ -f "plugins/cupp/cupp.py" ]; then
                echo -e "${GREEN}CUPP downloaded successfully! Starting interactive setup...${NC}"
                python3 plugins/cupp/cupp.py -i
            fi
        fi
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_sherlock() {
    clear
    echo -e "$BANNER_SHERLOCK"
    echo ""

    read -rp "Enter Username to search (e.g. johndoe): " TARGET_USER
    if [ -z "$TARGET_USER" ]; then return; fi

    echo ""
    echo -e "${GREEN}Searching for target: $TARGET_USER${NC}"
    echo "---------------------------------------------------"

    if command -v sherlock &> /dev/null; then
        sherlock "$TARGET_USER"
    elif [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock/sherlock.py "$TARGET_USER"
    elif [ -f "plugins/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock.py "$TARGET_USER"
    else
        echo -e "${YELLOW}Sherlock is not installed globally or in plugins/ directory.${NC}"
        read -rp "Would you like to clone Sherlock into plugins/ now? (y/n): " INSTALL_SHERLOCK
        if [[ "$INSTALL_SHERLOCK" =~ ^[Yy]$ ]]; then
            git clone https://github.com/sherlock-project/sherlock.git plugins/sherlock
            if [ -f "plugins/sherlock/requirements.txt" ]; then
                echo -e "${GREEN}Installing Python dependencies for Sherlock...${NC}"
                python3 -m pip install -r plugins/sherlock/requirements.txt
            fi
            if [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then
                echo -e "${GREEN}Sherlock downloaded! Executing search...${NC}"
                python3 plugins/sherlock/sherlock/sherlock.py "$TARGET_USER"
            fi
        fi
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_tcp_scanner() {
    clear
    echo -e "$BANNER_TCPSCANNER"
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
        echo -e "${RED}Error: Could not find plugins/tcp_scanner.py${NC}"
    fi

    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_aircrack() {
    clear
    echo -e "$BANNER_AIRCRACK"
    echo ""

    if ! command -v aircrack-ng &> /dev/null; then
        echo -e "${RED}Error: aircrack-ng is not installed on this system.${NC}"
        echo -e "${YELLOW}Install it via your package manager (e.g., sudo apt install aircrack-ng).${NC}"
        read -rp "Press Enter to continue..."
        return
    fi

    read -rp "Enter target .cap / .pcap capture file path: " CAP_FILE
    if [ -z "$CAP_FILE" ]; then return; fi

    read -rp "Enter wordlist file path (optional, press Enter to skip): " WORDLIST

    echo ""
    echo -e "${GREEN}Executing Aircrack-ng...${NC}"
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
    echo -e "$BANNER_SMSSPOOFER"
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
    echo -e "$BANNER_SMSSPOOFER"
    echo ""
    echo -e "${GREEN}Target:${NC}  $SMS_TARGET"
    echo -e "${GREEN}Spoof:${NC}   $SMS_SPOOF"
    echo -e "${GREEN}Message:${NC} ${SMS_MSG:0:50}${SMS_MSG:50:+"..."}"
    echo -e "${GREEN}Count:${NC}   $SMS_COUNT"
    echo -e "${GREEN}Threads:${NC} $SMS_THREADS"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/sms_spoofer.py" ]; then
        echo -e "${RED}Error: plugins/sms_spoofer.py not found!${NC}"
        echo -e "${YELLOW}Please ensure the SMS spoofer script is in the plugins/ directory.${NC}"
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
    echo -e "$BANNER_STARHUNT"
    echo ""

    read -rp "Enter Username to search: " TARGET_USER
    if [ -z "$TARGET_USER" ]; then return; fi

    read -rp "Enter Threads (default 20): " THREADS
    THREADS="${THREADS:-20}"

    read -rp "Enter Timeout (default 10s): " TIMEOUT
    TIMEOUT="${TIMEOUT:-10}"

    clear
    echo -e "$BANNER_STARHUNT"
    echo ""
    echo -e "${GREEN}Username:${NC} $TARGET_USER"
    echo -e "${GREEN}Threads:${NC}  $THREADS"
    echo -e "${GREEN}Timeout:${NC}  $TIMEOUT"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/starhunt.py" ]; then
        echo -e "${RED}Error: plugins/starhunt.py not found!${NC}"
        echo -e "${YELLOW}Please ensure the StarHunt script is in the plugins/ directory.${NC}"
        read -rp "Press Enter to continue..."
        return
    fi

    python3 plugins/starhunt.py "$TARGET_USER" --threads "$THREADS" --timeout "$TIMEOUT"

    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_meteor_strike() {
    clear
    echo -e "$BANNER_METEOR"
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
    echo -e "$BANNER_METEOR"
    echo ""
    echo -e "${GREEN}Target:${NC}    $TARGET"
    echo -e "${GREEN}Port:${NC}      $PORT"
    echo -e "${GREEN}Protocol:${NC}  $PROTO"
    echo -e "${GREEN}Threads:${NC}   $THREADS"
    echo -e "${GREEN}Duration:${NC}  $DURATION s"
    echo -e "${GREEN}Payload:${NC}   $PAYLOAD B"
    echo -e "${GREEN}Spoof:${NC}     ${SPOOF:-None}"
    echo "---------------------------------------------------"
    echo ""

    if [ ! -f "plugins/meteor_strike.py" ]; then
        echo -e "${RED}Error: plugins/meteor_strike.py not found!${NC}"
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
        13) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid selection, please try again.${NC}"; sleep 1 ;;
    esac
done
