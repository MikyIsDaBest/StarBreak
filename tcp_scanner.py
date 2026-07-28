# fixed by solez, original by mikes

import sys
import socket
import argparse
from concurrent.futures import ThreadPoolExecutor

def scan_port(host, port):
    """Attempts to connect to a specific TCP port."""
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.settimeout(1.0)
            result = s.connect_ex((host, port))
            if result == 0:
                print(f"  [+] Port {port:<5} is OPEN")
                return True
    except Exception:
        print(Exception)
    return False

def main():
    parser = argparse.ArgumentParser(description="Plugin: Fast TCP Port Scanner")
    parser.add_argument("--target", required=True, help="Target IP or Hostname")
    parser.add_argument("--start_port", type=int, default=1, help="Starting port (default: 1)")
    parser.add_argument("--end_port", type=int, default=1024, help="Ending port (default: 1024)")
    args = parser.parse_args()

    print(f"\n[===== Running Port Scanner Plugin =====]")
    print(f"Target: {args.target}")
    print(f"Range : {args.start_port} - {args.end_port}\n")

    try:
        # Resolve hostname
        target_ip = socket.gethostbyname(args.target)
    except socket.gaierror:
        print(f"[-] Error: Could not resolve hostname '{args.target}'")
        sys.exit(1) # Return Error Code 1 to Batch

    # Run scans across 50 concurrent threads for speed
    with ThreadPoolExecutor(max_workers=50) as executor:
        for port in range(args.start_port, args.end_port + 1):
            executor.submit(scan_port, target_ip, port)

    print(f"\n[+] Scan finished successfully.")
    sys.exit(0) # Return Success Code 0 to Batch

if __name__ == "__main__":
    main()