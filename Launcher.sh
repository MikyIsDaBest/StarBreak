#!/usr/bin/env bash

# Lock script directory so paths remain relative to launcher.sh
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Ensure directories exist
mkdir -p plugins logs reports output

# ==================== ANSI COLORS ====================
NC='\033[0m'              # No Color / Reset
BOLD='\033[1m'
DIM='\033[2m'

# Colors
CYAN='\033[0;36m'
B_CYAN='\033[1;36m'
BLUE='\033[0;34m'
B_BLUE='\033[1;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
B_PURPLE='\033[1;35m'
WHITE='\033[1;37m'
RED='\033[0;31m'
GRAY='\033[0;90m'

# ==================== ASCII BANNERS ====================
BANNER_NMAP="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███╗   ██╗███╗   ███╗ █████╗ ██████╗              │
│   ████╗  ██║████╗ ████║██╔══██╗██╔══██╗             │
│   ██╔██╗ ██║██╔████╔██║███████║██████╔╝             │
│   ██║╚██╗██║██║╚██╔╝██║██╔══██║██╔═══╝              │
│   ██║ ╚████║██║ ╚═╝ ██║██║  ██║██║                  │
│   ╚═╝  ╚═══╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝                  │
│            PORT SCANNER                             │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_WIRESHARK="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ╚╗ ╔╗╔╗╔╗ ╔╗╔╗ ╔╗╔╗╔╗ ╔╗╔╗╔╗╔╗                 │
│   ╔╝ ║║║║║║ ║║║║ ║║║║║║ ║║║║║║║║                 │
│   ╚═╝╚╝╚╝╚╝ ╚╝╚╝ ╚╝╚╝╚╝ ╚╝╚╝╚╝╚╝                 │
│            PACKET CAPTURE                           │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_NSLOOKUP="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███╗   ██╗███████╗██╗      ██████╗  ██████╗     │
│   ████╗  ██║██╔════╝██║     ██╔═══██╗██╔═══██╗    │
│   ██╔██╗ ██║███████╗██║     ██║   ██║██║   ██║    │
│   ██║╚██╗██║╚════██║██║     ██║   ██║██║   ██║    │
│   ██║ ╚████║███████║███████╗╚██████╔╝╚██████╔╝    │
│   ╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝  ╚═════╝     │
│            DNS LOOKUP                               │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_TCPSCANNER="${CYAN}
┌─────────────────────────────────────────────────────┐
│    ████████╗ ██████╗██████╗                         │
│    ╚══██╔══╝██╔════╝██╔══██╗                        │
│       ██║   ██║     ██████╔╝                        │
│       ██║   ██║     ██╔═══╝                         │
│       ██║   ╚██████╗██║                             │
│       ╚═╝    ╚═════╝╚═╝                             │
│            PORT SCANNER                             │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_SUBDOMAIN="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███████╗██╗   ██╗██████╗ ██████╗  ██████╗        │
│   ██╔════╝██║   ██║██╔══██╗██╔══██╗██╔═══██╗       │
│   ███████╗██║   ██║██████╔╝██║  ██║██║   ██║       │
│   ╚════██║██║   ██║██╔══██╗██║  ██║██║   ██║       │
│   ███████║╚██████╔╝██████╔╝██████╔╝╚██████╔╝       │
│   ╚══════╝ ╚═════╝ ╚═════╝ ╚═════╝  ╚═════╝        │
│            SUBDOMAIN ENUMERATION                    │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_SHERLOCK="${CYAN}
┌─────────────────────────────────────────────────────┐
│    ███████╗██╗  ██╗███████╗██████╗ ██╗      ██████╗ │
│    ██╔════╝██║  ██║██╔════╝██╔══██╗██║     ██╔═══██╗│
│    ███████╗███████║█████╗  ██████╔╝██║     ██║   ██║│
│    ╚════██║██╔══██║██╔══╝  ██╔══██╗██║     ██║   ██║│
│    ███████║██║  ██║███████╗██║  ██║███████╗╚██████╔╝│
│    ╚══════╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ │
│            OSINT LOOKUP                             │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_STARHUNT="${CYAN}
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
└─────────────────────────────────────────────────────┘${NC}"

BANNER_BREACH="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ██████╗ ██████╗ ███████╗ █████╗  ██████╗██╗  ██╗  │
│   ██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝██║  ██║  │
│   ██████╔╝██████╔╝█████╗  ███████║██║     ███████║  │
│   ██╔══██╗██╔══██╗██╔══╝  ██╔══██║██║     ██╔══██║  │
│   ██████╔╝██║  ██║███████╗██║  ██║╚██████╗██║  ██║  │
│   ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝  │
│            BREACH CHECKER ENGINE                    │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_EMAIL="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███████╗███╗   ███╗ █████╗ ██╗██╗                 │
│   ██╔════╝████╗ ████║██╔══██╗██║██║                 │
│   █████╗  ██╔████╔██║███████║██║██║                 │
│   ██╔══╝  ██║╚██╔╝██║██╔══██║██║██║                 │
│   ███████╗██║ ╚═╝ ██║██║  ██║██║███████╗            │
│   ╚══════╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝╚══════╝            │
│            EMAIL HUNTER ENGINE                      │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_STARSTRIKE="${CYAN}
┌─────────────────────────────────────────────────────┐
│    ███████╗████████╗ █████╗ ██████╗ ███████╗████████╗
│    ██╔════╝╚══██╔══╝██╔══██╗██╔══██╗██╔════╝╚══██╔══╝
│    ███████╗   ██║   ███████║██████╔╝███████╗   ██║   │
│    ╚════██║   ██║   ██╔══██║██╔══██╗╚════██║   ██║   │
│    ███████║   ██║   ██║  ██║██║  ██║███████║   ██║   │
│    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝   ╚═╝   │
│             STRIKE ENGINE                           │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_METEOR="${CYAN}
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
└─────────────────────────────────────────────────────┘${NC}"

BANNER_EXPLOIT="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███████╗██╗  ██╗██████╗ ██╗      ██████╗ ██╗████████╗
│   ██╔════╝╚██╗██╔╝██╔══██╗██║     ██╔═══██╗██║╚══██╔══╝
│   █████╗   ╚███╔╝ ██████╔╝██║     ██║   ██║██║   ██║   │
│   ██╔══╝   ██╔██╗ ██╔═══╝ ██║     ██║   ██║██║   ██║   │
│   ███████╗██╔╝ ██╗██║     ███████╗╚██████╔╝██║   ██║   │
│   ╚══════╝╚═╝  ╚═╝╚═╝     ╚══════╝ ╚═════╝ ╚═╝   ╚═╝   │
│            EXPLOIT SUGGESTER                        │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_AIRCRACK="${CYAN}
┌─────────────────────────────────────────────────────┐
│    █████╗ ██╗██████╗  ██████╗██████╗  █████╗  ██████╗
│   ██╔══██╗██║██╔══██╗██╔════╝██╔══██╗██╔══██╗██╔════╝
│   ███████║██║██████╔╝██║     ██████╔╝███████║██║     
│   ██╔══██║██║██╔══██╗██║     ██╔══██╗██╔══██║██║     
│   ██║  ██║██║██║  ██║╚██████╗██║  ██║██║  ██║╚██████╗
│   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝
│            WIRELESS SECURITY                        │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_SATELLITE="${CYAN}
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
└─────────────────────────────────────────────────────┘${NC}"

BANNER_PROXY="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ██████╗ ██████╗  ██████╗ ██╗  ██╗██╗   ██╗        │
│   ██╔══██╗██╔══██╗██╔═══██╗╚██╗██╔╝╚██╗ ██╔╝        │
│   ██████╔╝██████╔╝██║   ██║ ╚███╔╝  ╚████╔╝         │
│   ██╔═══╝ ██╔══██╗██║   ██║ ██╔██╗   ╚██╔╝          │
│   ██║     ██║  ██║╚██████╔╝██╔╝ ██╗   ██║           │
│   ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝           │
│            PROXY/ANONYMITY ENGINE                   │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_STEGANO="${CYAN}
┌─────────────────────────────────────────────────────┐
│   ███████╗████████╗███████╗ ██████╗  █████╗         │
│   ██╔════╝╚══██╔══╝██╔════╝██╔════╝ ██╔══██╗        │
│   ███████╗   ██║   █████╗  ██║  ███╗███████║        │
│   ╚════██║   ██║   ██╔══╝  ██║   ██║██╔══██║        │
│   ███████║   ██║   ███████╗╚██████╔╝██║  ██║        │
│   ╚══════╝   ╚═╝   ╚══════╝ ╚═════╝ ╚═════╝         │
│            STEGANOGRAPHY SUITE                      │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_CUPP="${CYAN}
┌─────────────────────────────────────────────────────┐
│    ██████╗██╗   ██╗██████╗ ██████╗                  │
│   ██╔════╝██║   ██║██╔══██╗██╔══██╗                 │
│   ██║     ██║   ██║██████╔╝██████╔╝                 │
│   ██║     ██║   ██║██╔═══╝ ██╔═══╝                  │
│   ╚██████╗╚██████╔╝██║     ██║                      │
│    ╚═════╝ ╚═════╝ ╚═╝     ╚═╝                      │
│            PASSWORD PROFILER                        │
└─────────────────────────────────────────────────────┘${NC}"

BANNER_SMSSPOOFER="${CYAN}
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
└─────────────────────────────────────────────────────┘${NC}"

# ==================== MENU ====================
show_menu() {
    clear
    echo -e "${B_BLUE}=================================================================${NC}"
    echo -e "${B_CYAN}    ____ _____  _    ____    ____  ____  _____    _    _  __ ${NC}"
    echo -e "${B_CYAN}   / ___|_   _|/ \  |  _ \  | __ )|  _ \| ____|  / \  | |/ / ${NC}"
    echo -e "${B_CYAN}   \___ \ | | / _ \ | |_) | |  _ \| |_) |  _|   / _ \ | ' /  ${NC}"
    echo -e "${B_CYAN}    ___) || |/ ___ \|  _ <  | |_) |  _ <| |___ / ___ \| . \  ${NC}"
    echo -e "${B_CYAN}   |____/ |_/_/   \_\_| \_\ |____/|_| \_\_____/_/   \_\_|\_\ ${NC}"
    echo ""
    echo -e "${GRAY}                     Made by ${WHITE}N E T W O R K 0${NC}"
    echo -e "${B_BLUE}=================================================================${NC}"
    echo -e "${B_PURPLE}                     NETWORK AND SECURITY SUITE           ${NC}"
    echo -e "${B_BLUE}=================================================================${NC}"
    echo ""
    echo -e "${YELLOW}   ═══ NETWORK & SCANNING ═══${NC}"
    echo -e "   [${B_CYAN}1${NC}]  Nmap - Port & Network Discovery"
    echo -e "   [${B_CYAN}2${NC}]  Wireshark - Packet Capture"
    echo -e "   [${B_CYAN}3${NC}]  Nslookup - DNS Lookup"
    echo -e "   [${B_CYAN}4${NC}]  TCP Port Scanner"
    echo -e "   [${B_CYAN}5${NC}]  Subdomain Enumerator"
    echo ""
    echo -e "${YELLOW}   ═══ OSINT & RECON ═══${NC}"
    echo -e "   [${B_CYAN}6${NC}]  Sherlock - OSINT Username Lookup"
    echo -e "   [${B_CYAN}7${NC}]  StarHunt - Advanced OSINT (50+ Platforms)"
    echo -e "   [${B_CYAN}8${NC}]  Breach Checker - Database Leak Search"
    echo -e "   [${B_CYAN}9${NC}]  Email Hunter"
    echo ""
    echo -e "${YELLOW}   ═══ EXPLOITATION & DOS ═══${NC}"
    echo -e "   [${B_CYAN}10${NC}] StarStrike - Guided Attack Engine"
    echo -e "   [${B_CYAN}11${NC}] StarStrike - Custom Raw Command"
    echo -e "   [${B_CYAN}12${NC}] M3T30R STR!K3 - Multi-Protocol DoS"
    echo -e "   [${B_CYAN}13${NC}] Exploit Suggester"
    echo ""
    echo -e "${YELLOW}   ═══ WIRELESS & PHYSICAL ═══${NC}"
    echo -e "   [${B_CYAN}14${NC}] Aircrack-ng - Wireless Security"
    echo -e "   [${B_CYAN}15${NC}] Satellite Reconnaissance"
    echo ""
    echo -e "${YELLOW}   ═══ ANONYMITY & STEALTH ═══${NC}"
    echo -e "   [${B_CYAN}16${NC}] Proxy/Anonymity Engine"
    echo -e "   [${B_CYAN}17${NC}] Steganography Suite"
    echo ""
    echo -e "${YELLOW}   ═══ PASSWORD & CREDENTIALS ═══${NC}"
    echo -e "   [${B_CYAN}18${NC}] CUPP - Password Profiler"
    echo -e "   [${B_CYAN}19${NC}] SMS Spoofer - Free SMS Spoofing"
    echo ""
    echo -e "   [${RED}20${NC}] ${RED}Exit${NC}"
    echo -e "${B_BLUE}=================================================================${NC}"
}

# Helper function for user inputs
prompt_input() {
    local text="$1"
    echo -ne "${B_CYAN}[?]${NC} ${WHITE}${text}${NC}"
}

# Helper function for errors
show_error() {
    echo -e "${RED}[!] Error:${NC} $1"
}

# ==================== FUNCTIONS ====================
run_nmap() {
    clear
    echo -e "$BANNER_NMAP\n"
    if ! command -v nmap &> /dev/null; then
        show_error "Nmap is not installed. Install with: sudo apt install nmap"
        read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
        return
    fi
    prompt_input "Enter Target IP/Subnet: "; read -r TARGET
    [ -z "$TARGET" ] && return
    prompt_input "Enter Scan Flags (default -F): "; read -r FLAGS
    FLAGS="${FLAGS:--F}"
    echo ""
    nmap $FLAGS "$TARGET"
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_wireshark() {
    clear
    echo -e "$BANNER_WIRESHARK\n"
    if command -v wireshark &> /dev/null; then
        echo -e "${CYAN}[*] Launching Wireshark in background...${NC}"
        wireshark &
    else
        show_error "Wireshark not installed."
    fi
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_nslookup() {
    clear
    echo -e "$BANNER_NSLOOKUP\n"
    prompt_input "Enter Domain or IP: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    nslookup "$TARGET"
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_tcp_scanner() {
    clear
    echo -e "$BANNER_TCPSCANNER\n"
    prompt_input "Enter Target IP/Hostname: "; read -r TARGET
    [ -z "$TARGET" ] && return
    prompt_input "Enter Start Port (default 1): "; read -r START
    START="${START:-1}"
    prompt_input "Enter End Port (default 1024): "; read -r END
    END="${END:-1024}"
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/tcp_scanner.py" ]; then
        python3 "$SCRIPT_DIR/plugins/tcp_scanner.py" --target "$TARGET" --start "$START" --end "$END"
    else
        show_error "$SCRIPT_DIR/plugins/tcp_scanner.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_subdomain_enum() {
    clear
    echo -e "$BANNER_SUBDOMAIN\n"
    prompt_input "Enter Domain: "; read -r DOMAIN
    [ -z "$DOMAIN" ] && return
    prompt_input "Enter Threads (default 20): "; read -r THREADS
    THREADS="${THREADS:-20}"
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/subdomain_enum.py" ]; then
        python3 "$SCRIPT_DIR/plugins/subdomain_enum.py" --domain "$DOMAIN" --threads "$THREADS"
    else
        show_error "$SCRIPT_DIR/plugins/subdomain_enum.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_sherlock() {
    clear
    echo -e "$BANNER_SHERLOCK\n"
    prompt_input "Enter Username: "; read -r USERNAME
    [ -z "$USERNAME" ] && return
    echo ""
    if command -v sherlock &> /dev/null; then
        sherlock "$USERNAME"
    elif [ -f "$SCRIPT_DIR/plugins/sherlock/sherlock.py" ]; then
        python3 "$SCRIPT_DIR/plugins/sherlock/sherlock.py" "$USERNAME"
    else
        show_error "Sherlock not found globally or in $SCRIPT_DIR/plugins/sherlock/"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_starhunt() {
    clear
    echo -e "$BANNER_STARHUNT\n"
    prompt_input "Enter Target: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/starhunt.py" ]; then
        python3 "$SCRIPT_DIR/plugins/starhunt.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/starhunt.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_breach() {
    clear
    echo -e "$BANNER_BREACH\n"
    prompt_input "Enter Target Query: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/breach_checker.py" ]; then
        python3 "$SCRIPT_DIR/plugins/breach_checker.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/breach_checker.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_email() {
    clear
    echo -e "$BANNER_EMAIL\n"
    prompt_input "Enter Target Domain/Email: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/email_hunter.py" ]; then
        python3 "$SCRIPT_DIR/plugins/email_hunter.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/email_hunter.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_starstrike() {
    clear
    echo -e "$BANNER_STARSTRIKE\n"
    prompt_input "Enter Target: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/starstrike.py" ]; then
        python3 "$SCRIPT_DIR/plugins/starstrike.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/starstrike.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_custom_raw() {
    clear
    echo -e "$BANNER_STARSTRIKE\n"
    prompt_input "Enter Custom Command: "; read -r CMD
    [ -z "$CMD" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/starstrike_raw.py" ]; then
        python3 "$SCRIPT_DIR/plugins/starstrike_raw.py" --cmd "$CMD"
    else
        show_error "$SCRIPT_DIR/plugins/starstrike_raw.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_meteor() {
    clear
    echo -e "$BANNER_METEOR\n"
    prompt_input "Enter Target IP/Hostname: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/meteor.py" ]; then
        python3 "$SCRIPT_DIR/plugins/meteor.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/meteor.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_exploit() {
    clear
    echo -e "$BANNER_EXPLOIT\n"
    prompt_input "Enter Target System/Service: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/exploit_suggester.py" ]; then
        python3 "$SCRIPT_DIR/plugins/exploit_suggester.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/exploit_suggester.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_aircrack() {
    clear
    echo -e "$BANNER_AIRCRACK\n"
    if ! command -v aircrack-ng &> /dev/null; then
        show_error "aircrack-ng is not installed."
        read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
        return
    fi
    prompt_input "Enter Target Cap File: "; read -r CAPFILE
    [ -z "$CAPFILE" ] && return
    echo ""
    if [ -f "$CAPFILE" ]; then
        aircrack-ng "$CAPFILE"
    else
        show_error "$CAPFILE not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_satellite() {
    clear
    echo -e "$BANNER_SATELLITE\n"
    prompt_input "Enter Target Coordinates/Area: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/satellite_recon.py" ]; then
        python3 "$SCRIPT_DIR/plugins/satellite_recon.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/satellite_recon.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_proxy() {
    clear
    echo -e "$BANNER_PROXY\n"
    if [ -f "$SCRIPT_DIR/plugins/proxy_engine.py" ]; then
        python3 "$SCRIPT_DIR/plugins/proxy_engine.py"
    else
        show_error "$SCRIPT_DIR/plugins/proxy_engine.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_stegano() {
    clear
    echo -e "$BANNER_STEGANO\n"
    prompt_input "Enter Image Path: "; read -r IMG
    [ -z "$IMG" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/stegano.py" ]; then
        python3 "$SCRIPT_DIR/plugins/stegano.py" "$IMG"
    else
        show_error "$SCRIPT_DIR/plugins/stegano.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_cupp() {
    clear
    echo -e "$BANNER_CUPP\n"
    if [ -f "$SCRIPT_DIR/plugins/cupp/cupp.py" ]; then
        python3 "$SCRIPT_DIR/plugins/cupp/cupp.py" -i
    else
        show_error "$SCRIPT_DIR/plugins/cupp/cupp.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

run_sms_spoofer() {
    clear
    echo -e "$BANNER_SMSSPOOFER\n"
    prompt_input "Enter Target Phone Number: "; read -r TARGET
    [ -z "$TARGET" ] && return
    echo ""
    if [ -f "$SCRIPT_DIR/plugins/sms_spoofer.py" ]; then
        python3 "$SCRIPT_DIR/plugins/sms_spoofer.py" "$TARGET"
    else
        show_error "$SCRIPT_DIR/plugins/sms_spoofer.py not found!"
    fi
    echo ""
    read -rp "$(echo -e ${GRAY}Press Enter to continue...${NC})"
}

# ==================== MAIN EXECUTION LOOP ====================
while true; do
    show_menu
    echo -ne "${B_CYAN}[>] Select an option [1-20]: ${NC}"
    read -r CHOICE
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
        20) echo -e "${RED}Exiting...${NC}"; exit 0 ;;
        *)  echo -e "${RED}Invalid option!${NC}"; sleep 1 ;;
    esac
done
