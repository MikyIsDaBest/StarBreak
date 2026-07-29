#!/usr/bin/env python3
import requests
import argparse
import threading
from concurrent.futures import ThreadPoolExecutor

SUBDOMAINS = [
    "www", "mail", "ftp", "localhost", "webmail", "smtp", "pop", "ns1", "webdisk",
    "ns2", "cpanel", "whm", "autodiscover", "autoconfig", "m", "imap", "test",
    "ns", "blog", "pop3", "dev", "www2", "admin", "forum", "news", "vpn", "ns3",
    "mail2", "new", "mysql", "old", "lists", "support", "mobile", "mx", "static",
    "docs", "beta", "shop", "sql", "secure", "demo", "cp", "calendar", "wiki",
    "web", "media", "email", "images", "img", "download", "dns", "piwik", "stats",
    "dashboard", "portal", "manage", "start", "info", "apps", "video", "sip",
    "dns2", "api", "cdn", "adfs", "remote", "server", "ftp2", "cluster"
]

def check_subdomain(domain, sub):
    url = f"http://{sub}.{domain}"
    try:
        r = requests.get(url, timeout=3)
        if r.status_code < 400:
            return url
    except:
        pass
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", required=True)
    parser.add_argument("--threads", type=int, default=20)
    args = parser.parse_args()
    
    print(f"\n[+] Enumerating subdomains for {args.domain}")
    print(f"[+] Total: {len(SUBDOMAINS)} subdomains\n")
    
    found = []
    with ThreadPoolExecutor(max_workers=args.threads) as executor:
        results = executor.map(lambda s: check_subdomain(args.domain, s), SUBDOMAINS)
        for result in results:
            if result:
                found.append(result)
                print(f"[+] Found: {result}")
    
    print(f"\n[+] Found {len(found)} subdomains")
    with open(f"subdomains_{args.domain}.txt", "w") as f:
        for url in found:
            f.write(url + "\n")

if __name__ == "__main__":
    main()
