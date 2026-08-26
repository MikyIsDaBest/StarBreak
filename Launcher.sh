#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1
mkdir -p plugins

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# ==================== BANNERS ====================
B_NMAP="
${CYAN}┌─────────────────────────────────────┐${NC}
${CYAN}│${NC}  ${WHITE}███╗   ██╗███╗   ███╗ █████╗ ██████╗${NC}  ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}████╗  ██║████╗ ████║██╔══██╗██╔══██╗${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}██╔██╗ ██║██╔████╔██║███████║██████╔╝${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝${NC}  ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}██║ ╚████║██║ ╚═╝ ██║██║  ██║██║${NC}      ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝${NC}      ${CYAN}│${NC}
${CYAN}│${NC}           ${WHITE}PORT SCANNER${NC}              ${CYAN}│${NC}
${CYAN}└─────────────────────────────────────┘${NC}"

B_WIRESHARK="
${YELLOW}┌─────────────────────────────────────┐${NC}
${YELLOW}│${NC}  ${WHITE}╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗${NC} ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║${NC} ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝${NC} ${YELLOW}│${NC}
${YELLOW}│${NC}        ${WHITE}PACKET CAPTURE${NC}             ${YELLOW}│${NC}
${YELLOW}└─────────────────────────────────────┘${NC}"

B_NSLOOKUP="
${BLUE}┌─────────────────────────────────────┐${NC}
${BLUE}│${NC}  ${WHITE}███╗   ██╗███████╗██╗      ██████╗  ██████╗${NC} ${BLUE}│${NC}
${BLUE}│${NC}  ${WHITE}████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗${NC}${BLUE}│${NC}
${BLUE}│${NC}  ${WHITE}██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║${NC}${BLUE}│${NC}
${BLUE}│${NC}  ${WHITE}██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║${NC}${BLUE}│${NC}
${BLUE}│${NC}  ${WHITE}██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝${NC}${BLUE}│${NC}
${BLUE}│${NC}  ${WHITE}╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝${NC} ${BLUE}│${NC}
${BLUE}│${NC}          ${WHITE}DNS LOOKUP${NC}                ${BLUE}│${NC}
${BLUE}└─────────────────────────────────────┘${NC}"

B_STARSTRIKE="
${RED}┌─────────────────────────────────────┐${NC}
${RED}│${NC}  ${WHITE}███████╗████████╗ █████╗ ██████╗ ███████╗████████╗${NC}
${RED}│${NC}  ${WHITE}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝${NC}
${RED}│${NC}  ${WHITE}███████╗   ██║   ███████║██████╔╝███████╗   ██║${NC}  ${RED}│${NC}
${RED}│${NC}  ${WHITE}╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║${NC}  ${RED}│${NC}
${RED}│${NC}  ${WHITE}███████║   ██║   ██║  ██║██║  ██║███████║   ██║${NC}  ${RED}│${NC}
${RED}│${NC}  ${WHITE}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝${NC}  ${RED}│${NC}
${RED}│${NC}          ${WHITE}STRIKE ENGINE${NC}              ${RED}│${NC}
${RED}└─────────────────────────────────────┘${NC}"

B_CUPP="
${MAGENTA}┌─────────────────────────────────────┐${NC}
${MAGENTA}│${NC}  ${WHITE}██████╗██╗   ██╗██████╗ ██████╗${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC} ${WHITE}██╔════╝██║   ██║██╔══██╗██╔══██╗${NC}  ${MAGENTA}│${NC}
${MAGENTA}│${NC} ${WHITE}██║     ██║   ██║██████╔╝██████╔╝${NC}  ${MAGENTA}│${NC}
${MAGENTA}│${NC} ${WHITE}██║     ██║   ██║██╔═══╝ ██╔═══╝${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC} ${WHITE}╚██████╗╚██████╔╝██║     ██║${NC}       ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}╚═════╝ ╚═════╝ ╚═╝     ╚═╝${NC}       ${MAGENTA}│${NC}
${MAGENTA}│${NC}       ${WHITE}PASSWORD PROFILER${NC}          ${MAGENTA}│${NC}
${MAGENTA}└─────────────────────────────────────┘${NC}"

B_SHERLOCK="
${GREEN}┌─────────────────────────────────────┐${NC}
${GREEN}│${NC}  ${WHITE}███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗${NC}
${GREEN}│${NC}  ${WHITE}██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗${NC}
${GREEN}│${NC}  ${WHITE}███████╗███████║█████╗  ██████╔╝██║     ██║   ██║${NC}
${GREEN}│${NC}  ${WHITE}╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║${NC}
${GREEN}│${NC}  ${WHITE}███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝${NC}
${GREEN}│${NC}  ${WHITE}╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝${NC} 
${GREEN}│${NC}        ${WHITE}OSINT LOOKUP${NC}               ${GREEN}│${NC}
${GREEN}└─────────────────────────────────────┘${NC}"

B_TCP="
${CYAN}┌─────────────────────────────────────┐${NC}
${CYAN}│${NC}  ${WHITE}████████╗ ██████╗██████╗${NC}          ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚══██╔══╝██╔════╝██╔══██╗${NC}         ${CYAN}│${NC}
${CYAN}│${NC}     ${WHITE}██║   ██║     ██████╔╝${NC}         ${CYAN}│${NC}
${CYAN}│${NC}     ${WHITE}██║   ██║     ██╔═══╝${NC}          ${CYAN}│${NC}
${CYAN}│${NC}     ${WHITE}██║   ╚██████╗██║${NC}              ${CYAN}│${NC}
${CYAN}│${NC}     ${WHITE}╚═╝    ╚═════╝╚═╝${NC}              ${CYAN}│${NC}
${CYAN}│${NC}        ${WHITE}PORT SCANNER${NC}               ${CYAN}│${NC}
${CYAN}└─────────────────────────────────────┘${NC}"

B_AIRCRACK="
${RED}┌─────────────────────────────────────┐${NC}
${RED}│${NC}  ${WHITE}█████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗${NC}
${RED}│${NC} ${WHITE}██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝${NC}
${RED}│${NC} ${WHITE}███████║██║██████╔╝██║     ██████╔╝███████║██║${NC}     
${RED}│${NC} ${WHITE}██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║${NC}     
${RED}│${NC} ${WHITE}██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗${NC}
${RED}│${NC} ${WHITE}╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝${NC}
${RED}│${NC}       ${WHITE}WIRELESS SECURITY${NC}          ${RED}│${NC}
${RED}└─────────────────────────────────────┘${NC}"

B_SMS="
${YELLOW}┌─────────────────────────────────────┐${NC}
${YELLOW}│${NC}  ${WHITE}███████╗███╗   ███╗███████╗${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}██╔════╝████╗ ████║██╔════╝${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}███████╗██╔████╔██║███████╗${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}╚════██║██║╚██╔╝██║╚════██║${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}███████║██║ ╚═╝ ██║███████║${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}╚══════╝╚═╝     ╚═╝╚══════╝${NC}  ${YELLOW}│${NC}
${YELLOW}│${NC}  ${WHITE}███████╗██████╗  ██████╗  ██████╗ ███████╗██████╗${NC}
${YELLOW}│${NC}  ${WHITE}██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██╔══██╗${NC}
${YELLOW}│${NC}  ${WHITE}███████╗██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝${NC}
${YELLOW}│${NC}  ${WHITE}╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝  ██╔══██╗${NC}
${YELLOW}│${NC}  ${WHITE}███████║██║     ╚██████╔╝╚██████╔╝███████╗██║  ██║${NC}
${YELLOW}│${NC}  ${WHITE}╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝${NC}
${YELLOW}│${NC}      ${WHITE}FREE SMS SPOOFING ENGINE${NC}      ${YELLOW}│${NC}
${YELLOW}└─────────────────────────────────────┘${NC}"

B_STARHUNT="
${MAGENTA}┌─────────────────────────────────────┐${NC}
${MAGENTA}│${NC}  ${WHITE}███████╗████████╗ █████╗ ██████╗${NC}  ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗${NC} ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}███████╗   ██║   ███████║██████╔╝${NC} ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}╚════██║   ██║   ██╔══██║██╔══██╗${NC} ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}███████║   ██║   ██║  ██║██║  ██║${NC} ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝${NC} ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}██╗  ██╗██╗   ██╗███╗   ██╗████████╗${NC}${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}██║  ██║██║   ██║████╗  ██║╚══██╔══╝${NC}${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}███████║██║   ██║██╔██╗ ██║   ██║${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}██╔══██║██║   ██║██║╚██╗██║   ██║${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}██║  ██║╚██████╔╝██║ ╚████║   ██║${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC}  ${WHITE}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝${NC}   ${MAGENTA}│${NC}
${MAGENTA}│${NC}    ${WHITE}ADVANCED OSINT - 50+ PLATFORMS${NC} ${MAGENTA}│${NC}
${MAGENTA}└─────────────────────────────────────┘${NC}"

B_METEOR="
${RED}┌─────────────────────────────────────┐${NC}
${RED}│${NC} ${WHITE}███╗   ███╗████████╗████████╗███████╗██████╗${NC} ${RED}│${NC}
${RED}│${NC} ${WHITE}████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}██╔████╔██║   ██║      ██║   █████╗  ██████╔╝${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}███████╗████████╗██████╗ ██╗██╗  ██╗███████╗${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}███████║   ██║   ██║  ██║██║██║  ██╗███████║${NC}${RED}│${NC}
${RED}│${NC} ${WHITE}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝${NC}${RED}│${NC}
${RED}│${NC}    ${WHITE}MULTI‑PROTOCOL DOS ENGINE${NC}      ${RED}│${NC}
${RED}└─────────────────────────────────────┘${NC}"

B_SATELLITE="
${CYAN}┌─────────────────────────────────────┐${NC}
${CYAN}│${NC}  ${WHITE}███████╗ █████╗ ████████╗███████╗██╗     ██╗${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║     ██║${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}███████╗███████║   ██║   █████╗  ██║     ██║${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚════██║██╔══██║   ██║   ██╔══╝  ██║     ██║${NC} ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}███████║██║  ██║   ██║   ███████╗███████╗███████╗${NC}${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝${NC}${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}███████╗██████╗  █████╗ ██████╗  ██████╗${NC}    ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗${NC}   ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}███████╗██████╔╝███████║██████╔╝██║   ██║${NC}   ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚════██║██╔══██╗██╔══██║██╔══██╗██║   ██║${NC}   ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}███████║██║  ██║██║  ██║██║  ██║╚██████╔╝${NC}   ${CYAN}│${NC}
${CYAN}│${NC}  ${WHITE}╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝${NC}    ${CYAN}│${NC}
${CYAN}│${NC}      ${WHITE}SATELLITE RECONNAISSANCE${NC}       ${CYAN}│${NC}
${CYAN}└─────────────────────────────────────┘${NC}"

# ==================== MENU ====================
menu() {
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
    echo -e "  ${WHITE}[${GREEN}1${WHITE}]${GREEN} Nmap - Port & Network Discovery${NC}"
    echo -e "  ${WHITE}[${GREEN}2${WHITE}]${YELLOW} Wireshark - Packet Capture${NC}"
    echo -e "  ${WHITE}[${GREEN}3${WHITE}]${BLUE} Nslookup - DNS Lookup${NC}"
    echo -e "  ${WHITE}[${GREEN}4${WHITE}]${RED} StarStrike - Guided Attack${NC}"
    echo -e "  ${WHITE}[${GREEN}5${WHITE}]${RED} StarStrike - Custom Raw Command${NC}"
    echo -e "  ${WHITE}[${GREEN}6${WHITE}]${MAGENTA} CUPP - Password Profiler${NC}"
    echo -e "  ${WHITE}[${GREEN}7${WHITE}]${GREEN} Sherlock - OSINT Username Lookup${NC}"
    echo -e "  ${WHITE}[${GREEN}8${WHITE}]${CYAN} TCP Port Scanner${NC}"
    echo -e "  ${WHITE}[${GREEN}9${WHITE}]${RED} Aircrack-ng - Wireless Security${NC}"
    echo -e "  ${WHITE}[${GREEN}10${WHITE}]${YELLOW} SMS Spoofer - Free SMS Spoofing${NC}"
    echo -e "  ${WHITE}[${GREEN}11${WHITE}]${MAGENTA} StarHunt - Advanced OSINT (50+ platforms)${NC}"
    echo -e "  ${WHITE}[${GREEN}12${WHITE}]${RED} M3T30R STR!K3 - Multi‑Protocol DoS${NC}"
    echo -e "  ${WHITE}[${GREEN}13${WHITE}]${CYAN} Satellite Reconnaissance${NC}"
    echo -e "  ${WHITE}[${GREEN}14${WHITE}]${YELLOW} Steel - DoS (Install)${NC}"
    echo -e "  ${WHITE}[${GREEN}15${WHITE}]${YELLOW} Steel - DoS (Guided)${NC}"
    echo -e "  ${WHITE}[${GREEN}16${WHITE}]${YELLOW} Steel - DoS (Raw)${NC}"
    echo -e "  ${WHITE}[${GREEN}17${WHITE}] Exit${NC}"
    echo -e "${CYAN}=================================================================${NC}"
}

# ==================== FUNCTIONS ====================
run_nmap() {
    clear
    echo -e "$B_NMAP"
    echo ""
    if ! command -v nmap &> /dev/null; then
        echo -e "${RED}Error: Nmap is not installed.${NC}"
        echo -e "${YELLOW}Install with: sudo apt install nmap${NC}"
        read -rp "Press Enter to continue..."
        return
    fi
    read -rp "Enter Target IP/Subnet: " TARGET
    if [ -z "$TARGET" ]; then
        return
    fi
    read -rp "Enter Scan Flags (default -F): " FLAGS
    FLAGS="${FLAGS:--F}"
    echo ""
    echo -e "${GREEN}Executing: nmap $FLAGS $TARGET${NC}"
    echo "---------------------------------------------------"
    nmap $FLAGS "$TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_wireshark() {
    clear
    echo -e "$B_WIRESHARK"
    echo ""
    if command -v wireshark &> /dev/null; then
        echo -e "${GREEN}Launching Wireshark...${NC}"
        wireshark &
        sleep 2
    else
        echo -e "${RED}Error: Wireshark is not installed.${NC}"
        echo -e "${YELLOW}Install with: sudo apt install wireshark${NC}"
    fi
    read -rp "Press Enter to continue..."
}

run_nslookup() {
    clear
    echo -e "$B_NSLOOKUP"
    echo ""
    read -rp "Enter Domain or IP Address: " TARGET
    if [ -z "$TARGET" ]; then
        return
    fi
    echo ""
    echo -e "${GREEN}Executing: nslookup $TARGET${NC}"
    echo "---------------------------------------------------"
    nslookup "$TARGET"
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_starstrike() {
    clear
    echo -e "$B_STARSTRIKE"
    echo ""
    read -rp "[1/4] Enter Victim Target IP: " VICTIM
    while [ -z "$VICTIM" ]; do
        read -rp "[1/4] Target required: " VICTIM
    done
    read -rp "[2/4] Enter Number of Threads (default 50): " THREADS
    THREADS="${THREADS:-50}"
    read -rp "[3/4] Enter Payload Size in bytes (default 65455): " PAYLOAD
    PAYLOAD="${PAYLOAD:-65455}"
    read -rp "[4/4] Enter Type (tcp/udp/icmp/http): " TYPE
    TYPE="${TYPE:-tcp}"
    clear
    echo -e "$B_STARSTRIKE"
    echo ""
    echo -e "${GREEN}Executing: python3 plugins/starstrike.py --threads${THREADS} --payloadsize${PAYLOAD} --type${TYPE} --victim${VICTIM}${NC}"
    echo "---------------------------------------------------"
    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    elif [ -f "plugins/starbreak.py" ]; then
        python3 plugins/starbreak.py "--threads${THREADS}" "--payloadsize${PAYLOAD}" "--type${TYPE}" "--victim${VICTIM}"
    else
        echo -e "${RED}Error: starstrike.py not found in plugins/.${NC}"
    fi
    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_custom_raw() {
    clear
    echo -e "$B_STARSTRIKE"
    echo ""
    echo -e "${YELLOW}Type the full argument string for starstrike.py${NC}"
    echo "Example: --threads50 --payloadsize65455 --typetcp --victim192.168.0.1"
    echo "---------------------------------------------------"
    read -rp "Enter flags: " RAW_ARGS
    echo ""
    echo -e "${GREEN}Executing: python3 plugins/starstrike.py $RAW_ARGS${NC}"
    echo "---------------------------------------------------"
    if [ -f "plugins/starstrike.py" ]; then
        python3 plugins/starstrike.py $RAW_ARGS
    else
        echo -e "${RED}Error: starstrike.py not found.${NC}"
    fi
    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

#get the steel repo and compile steel
install_steel() {
    clear
    echo -e "{WHITE}Installing Steel..."
    if command -v git &> /dev/null && command -v gcc &> /dev/null; then
        echo -e "Cloning repo..."
        git clone https://github.com/Vitalij3703/steel
        echo -e "Compiling..."
        gcc -pthread steel/steel.c -o plugins/steel
        echo -e "Installation done."
        chmod +x plugins/steel
        rm -rf steel/
    else
        echo -e "GCC and Git are required, but not installed. Abort"
    fi
}

#run steel with guided inputs
run_guided_steel() {
    echo -e "Steel (guided)"
    if [ -f "plugins/steel" ]; then
        #read -rp "Enter attack type [tcp, udp, icmp]: " _TYPE commented out because theres a bug
        read -rp "Enter target ip (x.x.x.x): " _IP
        read -rp "Enter target port: " _PORT
        read -rp "Enter number of threads (i recommend 10): " _THREADS
        read -rp "Enter any additional arguments (Leave empty to skip): " _ADD
        echo -e "Starting Steel... (It may not work, it is in development and prone to bugs. Report any bugs you encounter at the repo Vitalij3703/steel)"
        plugins/steel --targetip "{_IP}" --port "{_PORT}" --threads "{_THREADS}" "{_ADD}"
        return
    else
        echo -e "Steel not found. Install? [y/n]"
        read -rp "> " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            install_steel
        fi
    fi
}

run_raw_steel(){
    echo -e "Steel (raw)"
    if [ -f "plugins/steel" ]; then
        read -rp "Enter raw arguments: " _ADD
        echo -e "Starting Steel... (It may not work, it is in development and prone to bugs. Report any bugs you encounter at the repo Vitalij3703/steel)"
        plugins/steel "{_ADD}"
        return
    else
        echo -e "Steel not found. Install? [y/n]"
        read -rp "> " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            install_steel
        fi
    fi
}

run_cupp() {
    clear
    echo -e "$B_CUPP"
    echo ""
    if [ -f "plugins/cupp/cupp.py" ]; then
        python3 plugins/cupp/cupp.py -i
    elif [ -f "plugins/cupp.py" ]; then
        python3 plugins/cupp.py -i
    elif command -v cupp &> /dev/null; then
        cupp -i
    else
        echo -e "${YELLOW}CUPP not found. Clone? (y/n)${NC}"
        read -rp "> " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            git clone https://github.com/Mebus/cupp.git plugins/cupp
            if [ -f "plugins/cupp/cupp.py" ]; then
                echo -e "${GREEN}Downloaded! Starting...${NC}"
                python3 plugins/cupp/cupp.py -i
            fi
        fi
    fi
    read -rp "Press Enter to continue..."
}

run_sherlock() {
    clear
    echo -e "$B_SHERLOCK"
    echo ""
    read -rp "Enter Username: " USER
    if [ -z "$USER" ]; then
        return
    fi
    echo ""
    echo -e "${GREEN}Searching for $USER...${NC}"
    echo "---------------------------------------------------"
    if command -v sherlock &> /dev/null; then
        sherlock "$USER"
    elif [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock/sherlock.py "$USER"
    elif [ -f "plugins/sherlock/sherlock.py" ]; then
        python3 plugins/sherlock/sherlock.py "$USER"
    else
        echo -e "${YELLOW}Sherlock not found. Clone? (y/n)${NC}"
        read -rp "> " ans
        if [[ "$ans" =~ ^[Yy]$ ]]; then
            git clone https://github.com/sherlock-project/sherlock.git plugins/sherlock
            if [ -f "plugins/sherlock/requirements.txt" ]; then
                pip install -r plugins/sherlock/requirements.txt
            fi
            python3 plugins/sherlock/sherlock/sherlock.py "$USER"
        fi
    fi
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_tcp_scanner() {
    clear
    echo -e "$B_TCP"
    echo ""
    read -rp "Enter Target IP/Hostname: " TARGET
    if [ -z "$TARGET" ]; then
        return
    fi
    read -rp "Enter Start Port (default 1): " START
    START="${START:-1}"
    read -rp "Enter End Port (default 1024): " END
    END="${END:-1024}"
    echo ""
    echo "---------------------------------------------------"
    if [ -f "plugins/tcp_scanner.py" ]; then
        python3 plugins/tcp_scanner.py --target "$TARGET" --start_port "$START" --end_port "$END"
    else
        echo -e "${RED}Error: tcp_scanner.py not found.${NC}"
    fi
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_aircrack() {
    clear
    echo -e "$B_AIRCRACK"
    echo ""
    if ! command -v aircrack-ng &> /dev/null; then
        echo -e "${RED}Error: aircrack-ng is not installed.${NC}"
        echo -e "${YELLOW}Install with: sudo apt install aircrack-ng${NC}"
        read -rp "Press Enter to continue..."
        return
    fi
    read -rp "Enter target .cap/.pcap file path: " CAPFILE
    if [ -z "$CAPFILE" ]; then
        return
    fi
    read -rp "Enter wordlist (optional, press Enter to skip): " WORDLIST
    echo ""
    echo -e "${GREEN}Executing aircrack-ng...${NC}"
    echo "---------------------------------------------------"
    if [ -n "$WORDLIST" ]; then
        aircrack-ng -w "$WORDLIST" "$CAPFILE"
    else
        aircrack-ng "$CAPFILE"
    fi
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_sms_spoofer() {
    clear
    echo -e "$B_SMS"
    echo ""
    read -rp "Enter Target Phone Number (e.g., +1234567890): " TARGET
    if [ -z "$TARGET" ]; then
        return
    fi
    read -rp "Enter Spoofed Sender ID (e.g., +19998887777): " SPOOF
    if [ -z "$SPOOF" ]; then
        SPOOF="+00000000000"
    fi
    read -rp "Enter Message Content: " MSG
    if [ -z "$MSG" ]; then
        MSG="Hello from CATShadow Spoofer!"
    fi
    read -rp "Enter Number of Messages (default 10): " COUNT
    COUNT="${COUNT:-10}"
    read -rp "Enter Threads (default 5): " THREADS
    THREADS="${THREADS:-5}"
    clear
    echo -e "$B_SMS"
    echo ""
    echo -e "${GREEN}Target:${NC}  $TARGET"
    echo -e "${GREEN}Spoof:${NC}   $SPOOF"
    echo -e "${GREEN}Message:${NC} ${MSG:0:50}${MSG:50:+"..."}"
    echo -e "${GREEN}Count:${NC}   $COUNT"
    echo -e "${GREEN}Threads:${NC} $THREADS"
    echo "---------------------------------------------------"
    if [ ! -f "plugins/sms_spoofer.py" ]; then
        echo -e "${RED}Error: plugins/sms_spoofer.py not found!${NC}"
        read -rp "Press Enter to continue..."
        return
    fi
    python3 plugins/sms_spoofer.py \
        --target "$TARGET" \
        --spoof "$SPOOF" \
        --msg "$MSG" \
        --count "$COUNT" \
        --threads "$THREADS"
    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_starhunt() {
    clear
    echo -e "$B_STARHUNT"
    echo ""
    read -rp "Enter Username to search: " USER
    if [ -z "$USER" ]; then
        return
    fi
    read -rp "Enter Threads (default 20): " THREADS
    THREADS="${THREADS:-20}"
    read -rp "Enter Timeout (default 10s): " TIMEOUT
    TIMEOUT="${TIMEOUT:-10}"
    clear
    echo -e "$B_STARHUNT"
    echo ""
    echo -e "${GREEN}Username:${NC} $USER"
    echo -e "${GREEN}Threads:${NC}  $THREADS"
    echo -e "${GREEN}Timeout:${NC}  $TIMEOUT"
    echo "---------------------------------------------------"
    if [ ! -f "plugins/starhunt.py" ]; then
        echo -e "${RED}Error: plugins/starhunt.py not found!${NC}"
        read -rp "Press Enter to continue..."
        return
    fi
    python3 plugins/starhunt.py "$USER" --threads "$THREADS" --timeout "$TIMEOUT"
    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

run_meteor() {
    clear
    echo -e "$B_METEOR"
    echo ""
    read -rp "Enter Target IP or Domain: " TARGET
    if [ -z "$TARGET" ]; then
        return
    fi
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
    echo -e "$B_METEOR"
    echo ""
    echo -e "${GREEN}Target:${NC}    $TARGET"
    echo -e "${GREEN}Port:${NC}      $PORT"
    echo -e "${GREEN}Protocol:${NC}  $PROTO"
    echo -e "${GREEN}Threads:${NC}   $THREADS"
    echo -e "${GREEN}Duration:${NC}  $DURATION s"
    echo -e "${GREEN}Payload:${NC}   $PAYLOAD B"
    echo -e "${GREEN}Spoof:${NC}     ${SPOOF:-None}"
    echo "---------------------------------------------------"
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

run_satellite() {
    clear
    echo -e "$B_SATELLITE"
    echo ""
    read -rp "Enter Latitude: " LAT
    if [ -z "$LAT" ]; then
        return
    fi
    read -rp "Enter Longitude: " LON
    if [ -z "$LON" ]; then
        return
    fi
    clear
    echo -e "$B_SATELLITE"
    echo ""
    echo -e "${GREEN}Lat:${NC} $LAT"
    echo -e "${GREEN}Lon:${NC} $LON"
    echo "---------------------------------------------------"
    if [ ! -f "plugins/satellite_recon.py" ]; then
        echo -e "${RED}Error: plugins/satellite_recon.py not found!${NC}"
        read -rp "Press Enter to continue..."
        return
    fi
    python3 plugins/satellite_recon.py --lat "$LAT" --lon "$LON"
    echo ""
    echo "---------------------------------------------------"
    read -rp "Press Enter to continue..."
}

# ==================== MAIN LOOP ====================
while true; do
    menu
    read -rp "Select a tool [1-17]: " CHOICE
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
        12) run_meteor ;;
        13) run_satellite ;;
        14) install_steel ;;
        15) run_guided_steel ;;
        16) run_raw_steel ;;
        17) echo -e "${GREEN}Goodbye!${NC}"; exit 0 ;;
        *) echo -e "${RED}Invalid selection.${NC}"; sleep 1 ;;
    esac
done
