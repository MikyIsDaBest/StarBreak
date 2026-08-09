#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1
mkdir -p plugins

# Colors
R='\033[0;31m'; G='\033[0;32m'; Y='\033[1;33m'; B='\033[0;34m'
M='\033[0;35m'; C='\033[0;36m'; W='\033[1;37m'; N='\033[0m'

# Banners (compacted)
B_NMAP="
${C}┌─────────────────────────────────────┐${N}
${C}│${N}  ${W}███╗   ██╗███╗   ███╗ █████╗ ██████╗${N}  ${C}│${N}
${C}│${N}  ${W}████╗  ██║████╗ ████║██╔══██╗██╔══██╗${N} ${C}│${N}
${C}│${N}  ${W}██╔██╗ ██║██╔████╔██║███████║██████╔╝${N} ${C}│${N}
${C}│${N}  ${W}██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝${N}  ${C}│${N}
${C}│${N}  ${W}██║ ╚████║██║ ╚═╝ ██║██║  ██║██║${N}      ${C}│${N}
${C}│${N}  ${W}╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝${N}      ${C}│${N}
${C}│${N}           ${W}PORT SCANNER${N}              ${C}│${N}
${C}└─────────────────────────────────────┘${N}"

B_WIRESHARK="
${Y}┌─────────────────────────────────────┐${N}
${Y}│${N}  ${W}╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗${N} ${Y}│${N}
${Y}│${N}  ${W}╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║${N} ${Y}│${N}
${Y}│${N}  ${W}╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝${N} ${Y}│${N}
${Y}│${N}        ${W}PACKET CAPTURE${N}             ${Y}│${N}
${Y}└─────────────────────────────────────┘${N}"

B_NSLOOKUP="
${B}┌─────────────────────────────────────┐${N}
${B}│${N}  ${W}███╗   ██╗███████╗██╗      ██████╗  ██████╗${N} ${B}│${N}
${B}│${N}  ${W}████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗${N}${B}│${N}
${B}│${N}  ${W}██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║${N}${B}│${N}
${B}│${N}  ${W}██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║${N}${B}│${N}
${B}│${N}  ${W}██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝${N}${B}│${N}
${B}│${N}  ${W}╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝${N} ${B}│${N}
${B}│${N}          ${W}DNS LOOKUP${N}                ${B}│${N}
${B}└─────────────────────────────────────┘${N}"

B_STARSTRIKE="
${R}┌─────────────────────────────────────┐${N}
${R}│${N}  ${W}███████╗████████╗ █████╗ ██████╗ ███████╗████████╗${N}
${R}│${N}  ${W}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝${N}
${R}│${N}  ${W}███████╗   ██║   ███████║██████╔╝███████╗   ██║${N}  ${R}│${N}
${R}│${N}  ${W}╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║${N}  ${R}│${N}
${R}│${N}  ${W}███████║   ██║   ██║  ██║██║  ██║███████║   ██║${N}  ${R}│${N}
${R}│${N}  ${W}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝${N}  ${R}│${N}
${R}│${N}          ${W}STRIKE ENGINE${N}              ${R}│${N}
${R}└─────────────────────────────────────┘${N}"

B_CUPP="
${M}┌─────────────────────────────────────┐${N}
${M}│${N}  ${W}██████╗██╗   ██╗██████╗ ██████╗${N}   ${M}│${N}
${M}│${N} ${W}██╔════╝██║   ██║██╔══██╗██╔══██╗${N}  ${M}│${N}
${M}│${N} ${W}██║     ██║   ██║██████╔╝██████╔╝${N}  ${M}│${N}
${M}│${N} ${W}██║     ██║   ██║██╔═══╝ ██╔═══╝${N}   ${M}│${N}
${M}│${N} ${W}╚██████╗╚██████╔╝██║     ██║${N}       ${M}│${N}
${M}│${N}  ${W}╚═════╝ ╚═════╝ ╚═╝     ╚═╝${N}       ${M}│${N}
${M}│${N}       ${W}PASSWORD PROFILER${N}          ${M}│${N}
${M}└─────────────────────────────────────┘${N}"

B_SHERLOCK="
${G}┌─────────────────────────────────────┐${N}
${G}│${N}  ${W}███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗${N}
${G}│${N}  ${W}██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗${N}
${G}│${N}  ${W}███████╗███████║█████╗  ██████╔╝██║     ██║   ██║${N}
${G}│${N}  ${W}╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║${N}
${G}│${N}  ${W}███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝${N}
${G}│${N}  ${W}╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝${N} 
${G}│${N}        ${W}OSINT LOOKUP${N}               ${G}│${N}
${G}└─────────────────────────────────────┘${N}"

B_TCP="
${C}┌─────────────────────────────────────┐${N}
${C}│${N}  ${W}████████╗ ██████╗██████╗${N}          ${C}│${N}
${C}│${N}  ${W}╚══██╔══╝██╔════╝██╔══██╗${N}         ${C}│${N}
${C}│${N}     ${W}██║   ██║     ██████╔╝${N}         ${C}│${N}
${C}│${N}     ${W}██║   ██║     ██╔═══╝${N}          ${C}│${N}
${C}│${N}     ${W}██║   ╚██████╗██║${N}              ${C}│${N}
${C}│${N}     ${W}╚═╝    ╚═════╝╚═╝${N}              ${C}│${N}
${C}│${N}        ${W}PORT SCANNER${N}               ${C}│${N}
${C}└─────────────────────────────────────┘${N}"

B_AIRCRACK="
${R}┌─────────────────────────────────────┐${N}
${R}│${N}  ${W}█████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗${N}
${R}│${N} ${W}██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝${N}
${R}│${N} ${W}███████║██║██████╔╝██║     ██████╔╝███████║██║${N}     
${R}│${N} ${W}██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║${N}     
${R}│${N} ${W}██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗${N}
${R}│${N} ${W}╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝${N}
${R}│${N}       ${W}WIRELESS SECURITY${N}          ${R}│${N}
${R}└─────────────────────────────────────┘${N}"

B_SMS="
${Y}┌─────────────────────────────────────┐${N}
${Y}│${N}  ${W}███████╗███╗   ███╗███████╗${N}  ${Y}│${N}
${Y}│${N}  ${W}██╔════╝████╗ ████║██╔════╝${N}  ${Y}│${N}
${Y}│${N}  ${W}███████╗██╔████╔██║███████╗${N}  ${Y}│${N}
${Y}│${N}  ${W}╚════██║██║╚██╔╝██║╚════██║${N}  ${Y}│${N}
${Y}│${N}  ${W}███████║██║ ╚═╝ ██║███████║${N}  ${Y}│${N}
${Y}│${N}  ${W}╚══════╝╚═╝     ╚═╝╚══════╝${N}  ${Y}│${N}
${Y}│${N}  ${W}███████╗██████╗  ██████╗  ██████╗ ███████╗██████╗${N}
${Y}│${N}  ${W}██╔════╝██╔══██╗██╔═══██╗██╔═══██╗██╔════╝██╔══██╗${N}
${Y}│${N}  ${W}███████╗██████╔╝██║   ██║██║   ██║█████╗  ██████╔╝${N}
${Y}│${N}  ${W}╚════██║██╔═══╝ ██║   ██║██║   ██║██╔══╝  ██╔══██╗${N}
${Y}│${N}  ${W}███████║██║     ╚██████╔╝╚██████╔╝███████╗██║  ██║${N}
${Y}│${N}  ${W}╚══════╝╚═╝      ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝${N}
${Y}│${N}      ${W}FREE SMS SPOOFING ENGINE${N}      ${Y}│${N}
${Y}└─────────────────────────────────────┘${N}"

B_STARHUNT="
${M}┌─────────────────────────────────────┐${N}
${M}│${N}  ${W}███████╗████████╗ █████╗ ██████╗${N}  ${M}│${N}
${M}│${N}  ${W}██╔════╝╚══██╔══╝██╔══██╗██╔══██╗${N} ${M}│${N}
${M}│${N}  ${W}███████╗   ██║   ███████║██████╔╝${N} ${M}│${N}
${M}│${N}  ${W}╚════██║   ██║   ██╔══██║██╔══██╗${N} ${M}│${N}
${M}│${N}  ${W}███████║   ██║   ██║  ██║██║  ██║${N} ${M}│${N}
${M}│${N}  ${W}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝${N} ${M}│${N}
${M}│${N}  ${W}██╗  ██╗██╗   ██╗███╗   ██╗████████╗${N}${M}│${N}
${M}│${N}  ${W}██║  ██║██║   ██║████╗  ██║╚══██╔══╝${N}${M}│${N}
${M}│${N}  ${W}███████║██║   ██║██╔██╗ ██║   ██║${N}   ${M}│${N}
${M}│${N}  ${W}██╔══██║██║   ██║██║╚██╗██║   ██║${N}   ${M}│${N}
${M}│${N}  ${W}██║  ██║╚██████╔╝██║ ╚████║   ██║${N}   ${M}│${N}
${M}│${N}  ${W}╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝   ╚═╝${N}   ${M}│${N}
${M}│${N}    ${W}ADVANCED OSINT - 50+ PLATFORMS${N} ${M}│${N}
${M}└─────────────────────────────────────┘${N}"

B_METEOR="
${R}┌─────────────────────────────────────┐${N}
${R}│${N} ${W}███╗   ███╗████████╗████████╗███████╗██████╗${N} ${R}│${N}
${R}│${N} ${W}████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗${N}${R}│${N}
${R}│${N} ${W}██╔████╔██║   ██║      ██║   █████╗  ██████╔╝${N}${R}│${N}
${R}│${N} ${W}██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗${N}${R}│${N}
${R}│${N} ${W}██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║${N}${R}│${N}
${R}│${N} ${W}╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝${N}${R}│${N}
${R}│${N} ${W}███████╗████████╗██████╗ ██╗██╗  ██╗███████╗${N}${R}│${N}
${R}│${N} ${W}██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝${N}${R}│${N}
${R}│${N} ${W}███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗${N}${R}│${N}
${R}│${N} ${W}╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║${N}${R}│${N}
${R}│${N} ${W}███████║   ██║   ██║  ██║██║██║  ██╗███████║${N}${R}│${N}
${R}│${N} ${W}╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝${N}${R}│${N}
${R}│${N}    ${W}MULTI‑PROTOCOL DOS ENGINE${N}      ${R}│${N}
${R}└─────────────────────────────────────┘${N}"

B_SATELLITE="
${C}┌─────────────────────────────────────┐${N}
${C}│${N}  ${W}███████╗ █████╗ ████████╗███████╗██╗     ██╗${N} ${C}│${N}
${C}│${N}  ${W}██╔════╝██╔══██╗╚══██╔══╝██╔════╝██║     ██║${N} ${C}│${N}
${C}│${N}  ${W}███████╗███████║   ██║   █████╗  ██║     ██║${N} ${C}│${N}
${C}│${N}  ${W}╚════██║██╔══██║   ██║   ██╔══╝  ██║     ██║${N} ${C}│${N}
${C}│${N}  ${W}███████║██║  ██║   ██║   ███████╗███████╗███████╗${N}${C}│${N}
${C}│${N}  ${W}╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚══════╝╚══════╝${N}${C}│${N}
${C}│${N}  ${W}███████╗██████╗  █████╗ ██████╗  ██████╗${N}    ${C}│${N}
${C}│${N}  ${W}██╔════╝██╔══██╗██╔══██╗██╔══██╗██╔═══██╗${N}   ${C}│${N}
${C}│${N}  ${W}███████╗██████╔╝███████║██████╔╝██║   ██║${N}   ${C}│${N}
${C}│${N}  ${W}╚════██║██╔══██╗██╔══██║██╔══██╗██║   ██║${N}   ${C}│${N}
${C}│${N}  ${W}███████║██║  ██║██║  ██║██║  ██║╚██████╔╝${N}   ${C}│${N}
${C}│${N}  ${W}╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝${N}    ${C}│${N}
${C}│${N}      ${W}SATELLITE RECONNAISSANCE${N}       ${C}│${N}
${C}└─────────────────────────────────────┘${N}"

# ==================== MENU ====================
menu() {
    clear
    echo -e "${C}=================================================================${N}"
    echo -e "${G}   ____ _____  _    ____    ____  ____  _____    _    _  __ ${N}"
    echo -e "${G}  / ___|_   _|/ \  |  _ \  | __ )|  _ \| ____|  / \  | |/ / ${N}"
    echo -e "${G}  \___ \ | | / _ \ | |_) | |  _ \| |_) |  _|   / _ \ | ' /  ${N}"
    echo -e "${G}   ___) || |/ ___ \|  _ <  | |_) |  _ <| |___ / ___ \| . \  ${N}"
    echo -e "${G}  |____/ |_/_/   \_\_| \_\ |____/|_| \_\_____/_/   \_\_|\_\ ${N}"
    echo ""
    echo -e "${Y}                     Made by N E T W O R K 0             ${N}"
    echo -e "${C}=================================================================${N}"
    echo -e "${C}                     NETWORK AND SECURITY SUITE           ${N}"
    echo -e "${C}=================================================================${N}"
    echo -e "  ${W}[${G}1${W}]${G} Nmap - Port & Network Discovery${N}"
    echo -e "  ${W}[${G}2${W}]${Y} Wireshark - Packet Capture${N}"
    echo -e "  ${W}[${G}3${W}]${B} Nslookup - DNS Lookup${N}"
    echo -e "  ${W}[${G}4${W}]${R} StarStrike - Guided Attack${N}"
    echo -e "  ${W}[${G}5${W}]${R} StarStrike - Custom Raw Command${N}"
    echo -e "  ${W}[${G}6${W}]${M} CUPP - Password Profiler${N}"
    echo -e "  ${W}[${G}7${W}]${G} Sherlock - OSINT Username Lookup${N}"
    echo -e "  ${W}[${G}8${W}]${C} TCP Port Scanner${N}"
    echo -e "  ${W}[${G}9${W}]${R} Aircrack-ng - Wireless Security${N}"
    echo -e "  ${W}[${G}10${W}]${Y} SMS Spoofer - Free SMS Spoofing${N}"
    echo -e "  ${W}[${G}11${W}]${M} StarHunt - Advanced OSINT (50+ platforms)${N}"
    echo -e "  ${W}[${G}12${W}]${R} M3T30R STR!K3 - Multi‑Protocol DoS${N}"
    echo -e "  ${W}[${G}13${W}]${C} Satellite Reconnaissance${N}"
    echo -e "  ${W}[${G}14${W}] Exit${N}"
    echo -e "${C}=================================================================${N}"
}

# ==================== FUNCTIONS ====================
run_nmap() { clear; echo -e "$B_NMAP"; echo ""; if ! command -v nmap &>/dev/null; then echo -e "${R}Error: Nmap not installed.${N}"; read -rp "Press Enter..."; return; fi; read -rp "Target: " T; [ -z "$T" ] && return; read -rp "Flags (default -F): " F; F="${F:--F}"; echo ""; nmap $F "$T"; read -rp "Press Enter..."; }
run_wireshark() { clear; echo -e "$B_WIRESHARK"; echo ""; if command -v wireshark &>/dev/null; then wireshark &; else echo -e "${R}Error: Wireshark not installed.${N}"; fi; read -rp "Press Enter..."; }
run_nslookup() { clear; echo -e "$B_NSLOOKUP"; echo ""; read -rp "Domain/IP: " T; [ -z "$T" ] && return; echo ""; nslookup "$T"; read -rp "Press Enter..."; }
run_starstrike() { clear; echo -e "$B_STARSTRIKE"; echo ""; read -rp "[1/4] Target IP: " V; while [ -z "$V" ]; do read -rp "[1/4] Target required: " V; done; read -rp "[2/4] Threads (50): " TH; TH="${TH:-50}"; read -rp "[3/4] Payload size (65455): " PL; PL="${PL:-65455}"; read -rp "[4/4] Type (tcp/udp/icmp/http): " TY; TY="${TY:-tcp}"; clear; echo -e "$B_STARSTRIKE"; echo ""; echo -e "${G}Executing: python3 plugins/starstrike.py --threads${TH} --payloadsize${PL} --type${TY} --victim${V}${N}"; if [ -f "plugins/starstrike.py" ]; then python3 plugins/starstrike.py "--threads${TH}" "--payloadsize${PL}" "--type${TY}" "--victim${V}"; elif [ -f "plugins/starbreak.py" ]; then python3 plugins/starbreak.py "--threads${TH}" "--payloadsize${PL}" "--type${TY}" "--victim${V}"; else echo -e "${R}Error: starstrike.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_custom_raw() { clear; echo -e "$B_STARSTRIKE"; echo ""; echo -e "${Y}Enter raw arguments for starstrike.py${N}"; echo "Example: --threads50 --payloadsize65455 --typetcp --victim192.168.0.1"; read -rp "> " ARGS; echo ""; if [ -f "plugins/starstrike.py" ]; then python3 plugins/starstrike.py $ARGS; else echo -e "${R}Error: starstrike.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_cupp() { clear; echo -e "$B_CUPP"; echo ""; if [ -f "plugins/cupp/cupp.py" ]; then python3 plugins/cupp/cupp.py -i; elif [ -f "plugins/cupp.py" ]; then python3 plugins/cupp.py -i; elif command -v cupp &>/dev/null; then cupp -i; else echo -e "${Y}CUPP not found. Clone? (y/n)${N}"; read -rp "> " ans; if [[ "$ans" =~ ^[Yy]$ ]]; then git clone https://github.com/Mebus/cupp.git plugins/cupp && python3 plugins/cupp/cupp.py -i; fi; fi; read -rp "Press Enter..."; }
run_sherlock() { clear; echo -e "$B_SHERLOCK"; echo ""; read -rp "Username: " U; [ -z "$U" ] && return; echo ""; if command -v sherlock &>/dev/null; then sherlock "$U"; elif [ -f "plugins/sherlock/sherlock/sherlock.py" ]; then python3 plugins/sherlock/sherlock/sherlock.py "$U"; elif [ -f "plugins/sherlock/sherlock.py" ]; then python3 plugins/sherlock/sherlock.py "$U"; else echo -e "${Y}Sherlock not found. Clone? (y/n)${N}"; read -rp "> " ans; if [[ "$ans" =~ ^[Yy]$ ]]; then git clone https://github.com/sherlock-project/sherlock.git plugins/sherlock; pip install -r plugins/sherlock/requirements.txt; python3 plugins/sherlock/sherlock/sherlock.py "$U"; fi; fi; read -rp "Press Enter..."; }
run_tcp_scanner() { clear; echo -e "$B_TCP"; echo ""; read -rp "Target: " T; [ -z "$T" ] && return; read -rp "Start port (1): " SP; SP="${SP:-1}"; read -rp "End port (1024): " EP; EP="${EP:-1024}"; echo ""; if [ -f "plugins/tcp_scanner.py" ]; then python3 plugins/tcp_scanner.py --target "$T" --start_port "$SP" --end_port "$EP"; else echo -e "${R}Error: tcp_scanner.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_aircrack() { clear; echo -e "$B_AIRCRACK"; echo ""; if ! command -v aircrack-ng &>/dev/null; then echo -e "${R}Error: aircrack-ng not installed.${N}"; read -rp "Press Enter..."; return; fi; read -rp "Capture file (.cap): " CF; [ -z "$CF" ] && return; read -rp "Wordlist (optional): " WL; echo ""; if [ -n "$WL" ]; then aircrack-ng -w "$WL" "$CF"; else aircrack-ng "$CF"; fi; read -rp "Press Enter..."; }
run_sms_spoofer() { clear; echo -e "$B_SMS"; echo ""; read -rp "Target phone: " T; [ -z "$T" ] && return; read -rp "Spoof ID: " S; S="${S:-+00000000000}"; read -rp "Message: " M; M="${M:-Hello from CATShadow}"; read -rp "Count (10): " C; C="${C:-10}"; read -rp "Threads (5): " TH; TH="${TH:-5}"; clear; echo -e "$B_SMS"; echo ""; echo -e "${G}Target:${N} $T"; echo -e "${G}Spoof:${N}  $S"; echo -e "${G}Msg:${N}   ${M:0:50}"; echo -e "${G}Count:${N}  $C"; echo -e "${G}Threads:${N}$TH"; echo ""; if [ -f "plugins/sms_spoofer.py" ]; then python3 plugins/sms_spoofer.py --target "$T" --spoof "$S" --msg "$M" --count "$C" --threads "$TH"; else echo -e "${R}Error: sms_spoofer.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_starhunt() { clear; echo -e "$B_STARHUNT"; echo ""; read -rp "Username: " U; [ -z "$U" ] && return; read -rp "Threads (20): " TH; TH="${TH:-20}"; read -rp "Timeout (10s): " TO; TO="${TO:-10}"; clear; echo -e "$B_STARHUNT"; echo ""; echo -e "${G}Username:${N} $U"; echo -e "${G}Threads:${N}  $TH"; echo -e "${G}Timeout:${N}  $TO"; echo ""; if [ -f "plugins/starhunt.py" ]; then python3 plugins/starhunt.py "$U" --threads "$TH" --timeout "$TO"; else echo -e "${R}Error: starhunt.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_meteor() { clear; echo -e "$B_METEOR"; echo ""; read -rp "Target IP/Domain: " T; [ -z "$T" ] && return; read -rp "Port (80): " P; P="${P:-80}"; read -rp "Protocol (tcp/udp/icmp/http): " PR; PR="${PR:-tcp}"; read -rp "Threads (50): " TH; TH="${TH:-50}"; read -rp "Duration (30s): " D; D="${D:-30}"; read -rp "Payload size (1024): " PL; PL="${PL:-1024}"; read -rp "Spoof IP (optional): " SP; clear; echo -e "$B_METEOR"; echo ""; echo -e "${G}Target:${N} $T"; echo -e "${G}Port:${N} $P"; echo -e "${G}Protocol:${N} $PR"; echo -e "${G}Threads:${N} $TH"; echo -e "${G}Duration:${N} $D s"; echo -e "${G}Payload:${N} $PL B"; echo -e "${G}Spoof:${N} ${SP:-None}"; echo ""; if [ -f "plugins/meteor_strike.py" ]; then python3 plugins/meteor_strike.py --target "$T" --port "$P" --protocol "$PR" --threads "$TH" --duration "$D" --payload "$PL" ${SP:+--spoof "$SP"}; else echo -e "${R}Error: meteor_strike.py not found.${N}"; fi; read -rp "Press Enter..."; }
run_satellite() { clear; echo -e "$B_SATELLITE"; echo ""; read -rp "Latitude: " LAT; [ -z "$LAT" ] && return; read -rp "Longitude: " LON; [ -z "$LON" ] && return; clear; echo -e "$B_SATELLITE"; echo ""; echo -e "${G}Lat:${N} $LAT"; echo -e "${G}Lon:${N} $LON"; echo ""; if [ -f "plugins/satellite_recon.py" ]; then python3 plugins/satellite_recon.py --lat "$LAT" --lon "$LON"; else echo -e "${R}Error: satellite_recon.py not found.${N}"; fi; read -rp "Press Enter..."; }

# ==================== MAIN LOOP ====================
while true; do
    menu
    read -rp "Select [1-14]: " CHOICE
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
        14) echo -e "${G}Goodbye!${N}"; exit 0 ;;
        *) echo -e "${R}Invalid.${N}"; sleep 1 ;;
    esac
done
