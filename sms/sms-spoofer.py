#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SMS Spoofer, tool done by @avgeek_mikes10
Usage: python shadow.py --module sms --target +1234567890 --spoof +19998887777 --msg "Hello" --count 10
"""

import sys
import argparse
import importlib
import pkgutil
import inspect
from typing import Dict, Callable, Any

# ==================== CORE DISPATCHER ====================
class ShadowTool:
    """Master launcher for CATShadow tool suite"""
    
    _modules: Dict[str, Callable] = {}
    
    @classmethod
    def register(cls, name: str, func: Callable):
        """Decorator to register a command module"""
        cls._modules[name] = func
        return func
    
    @classmethod
    def run(cls, args: argparse.Namespace):
        """Execute the requested module with arguments"""
        module_name = args.module.lower()
        if module_name not in cls._modules:
            print(f"[!] Unknown module: {module_name}")
            print(f"[i] Available: {', '.join(cls._modules.keys())}")
            sys.exit(1)
        
        # Convert args namespace to dict, filter None
        params = {k: v for k, v in vars(args).items() if v is not None}
        params.pop('module', None)
        
        # Execute module
        print(f"[+] Launching {module_name}...")
        cls._modules[module_name](**params)

# ==================== MODULE: SMS SPOOFER ====================
@ShadowTool.register("sms")
def sms_spoofer(target: str, spoof: str, msg: str, count: int = 10, threads: int = 5, retries: int = 3, delay: float = 0.8):
    """
    SMS Spoofing Module
    --target     Recipient phone number (e.g., +1234567890)
    --spoof      Sender ID to display
    --msg        Message content
    --count      Number of messages to send (default: 10)
    --threads    Concurrent threads (default: 5)
    --retries    Retry attempts per message (default: 3)
    --delay      Delay between sends in seconds (default: 0.8)
    """
    import time, random, threading, requests
    from concurrent.futures import ThreadPoolExecutor
    
    # Carrier gateways (free)
    CARRIER_GATEWAYS = {
        "att": "txt.att.net", "tmobile": "tmomail.net",
        "verizon": "vtext.com", "sprint": "messaging.sprintpcs.com",
        "google": "msg.fi.google.com", "boost": "myboostmobile.com",
        "cricket": "mms.cricketwireless.net", "uscellular": "email.uscc.net"
    }
    
    success_count = 0
    fail_count = 0
    lock = threading.Lock()
    
    def send_sms(phone: str, message: str, sender: str) -> bool:
        # Try carrier gateway
        carrier = random.choice(list(CARRIER_GATEWAYS.keys()))
        domain = CARRIER_GATEWAYS.get(carrier)
        if domain:
            try:
                recipient = f"{phone}@{domain}"
                resp = requests.post(
                    "https://api.mailgun.net/v3/sandbox.mailgun.org/messages",
                    auth=("api", "key-dummy"),  # replace with real or use local SMTP
                    data={
                        "from": f"{sender} <spoof@shadow.cat>",
                        "to": recipient,
                        "subject": f"Message from {sender}",
                        "text": message
                    },
                    timeout=10
                )
                if resp.status_code in (200, 202):
                    return True
            except:
                pass
        
        # Fallback: public SMS gateways
        endpoints = [
            "https://textbelt.com/text",
            "https://smsapi.free-mobile.fr/sendmsg",
            "https://api.callmebot.com/sms/send.php"
        ]
        for url in endpoints:
            try:
                data = {"phone": phone, "message": message, "sender": sender, "key": "guest"}
                resp = requests.post(url, data=data, timeout=8)
                if resp.status_code == 200:
                    return True
            except:
                continue
        return False
    
    def worker(iteration):
        nonlocal success_count, fail_count
        for i in range(count):
            sent = False
            for _ in range(retries):
                if send_sms(target, msg, spoof):
                    sent = True
                    break
                time.sleep(0.5)
            with lock:
                if sent:
                    success_count += 1
                    print(f"[✓] #{iteration+1}.{i+1} sent to {target}")
                else:
                    fail_count += 1
                    print(f"[✗] #{iteration+1}.{i+1} failed")
            time.sleep(delay + random.uniform(0, 0.3))
    
    print(f"\n[>] SMS Spoof Module")
    print(f"    Target: {target}")
    print(f"    Spoof:  {spoof}")
    print(f"    Msg:    {msg[:50]}{'...' if len(msg)>50 else ''}")
    print(f"    Count:  {count} per thread | Threads: {threads} | Retries: {retries}\n")
    
    with ThreadPoolExecutor(max_workers=threads) as executor:
        futures = [executor.submit(worker, i) for i in range(threads)]
        for f in futures:
            f.result()
    
    print(f"\n[+] SMS Module Complete | Success: {success_count} | Failed: {fail_count}")

# ==================== MODULE: TEMPLATE (for future tools) ====================
@ShadowTool.register("ping")
def ping_module(target: str, count: int = 4):
    """
    Network ping module (example)
    --target   IP or hostname
    --count    Number of pings (default: 4)
    """
    import subprocess
    print(f"[>] Pinging {target} {count} times...")
    try:
        result = subprocess.run(["ping", "-c", str(count), target], capture_output=True, text=True)
        print(result.stdout)
    except Exception as e:
        print(f"[!] Ping failed: {e}")

# ==================== MODULE: INFO / HELP ====================
@ShadowTool.register("help")
def show_help(**kwargs):
    """Display all available modules and their parameters"""
    print("\n" + "="*60)
    print("  CATShadow Multitool Launcher v5.0.0")
    print("="*60)
    for name, func in ShadowTool._modules.items():
        print(f"\n[{name}]")
        # Get docstring and extract args
        doc = func.__doc__ or "No description"
        lines = doc.strip().split('\n')
        print(f"  {lines[0]}")
        for line in lines[1:]:
            if '--' in line:
                print(f"    {line.strip()}")
    print("\n" + "="*60)
    print("Example: python shadow.py --module sms --target +123 --spoof +456 --msg 'Hello' --count 5")

# ==================== MAIN PARSER ====================
def main():
    parser = argparse.ArgumentParser(
        description="CATShadow Multitool Framework",
        usage="python shadow.py --module <name> [options]"
    )
    parser.add_argument("--module", "-m", required=True, help="Module to execute")
    
    # Generic flags (used by multiple modules)
    parser.add_argument("--target", "-t", help="Target IP, phone, or hostname")
    parser.add_argument("--spoof", "-s", help="Spoofed sender ID or IP")
    parser.add_argument("--msg", help="Message content")
    parser.add_argument("--count", "-c", type=int, default=10, help="Number of iterations")
    parser.add_argument("--threads", type=int, default=5, help="Concurrent threads")
    parser.add_argument("--retries", type=int, default=3, help="Retry attempts")
    parser.add_argument("--delay", type=float, default=0.8, help="Delay between sends")
    
    # Catch-all for future parameters (ignored by dispatcher but available)
    args, unknown = parser.parse_known_args()
    
    # Add unknown args as attributes if needed (for future expansion)
    for arg in unknown:
        if arg.startswith("--"):
            key = arg[2:]
            # We don't store values here, but could be extended
    
    # Run the dispatcher
    ShadowTool.run(args)

if __name__ == "__main__":
    main()
