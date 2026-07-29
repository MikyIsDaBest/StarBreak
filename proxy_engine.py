#!/usr/bin/env python3
import requests
import random
import argparse
import time

class ProxyEngine:
    def __init__(self):
        self.proxies = []
        self.current = 0
    
    def load_proxies(self):
        """Load proxies from free sources"""
        urls = [
            "https://api.proxyscrape.com/v2/?request=displayproxies&protocol=http&timeout=10000&country=all&ssl=all&anonymity=all",
            "https://www.proxy-list.download/api/v1/get?type=http",
            "https://raw.githubusercontent.com/clarketm/proxy-list/master/proxy-list-raw.txt"
        ]
        for url in urls:
            try:
                r = requests.get(url, timeout=10)
                proxies = r.text.strip().split('\n')
                for p in proxies:
                    if ':' in p:
                        self.proxies.append(p)
                print(f"[+] Loaded {len(proxies)} proxies from {url}")
            except:
                continue
        
        print(f"[+] Total proxies loaded: {len(self.proxies)}")
    
    def get_proxy(self):
        if not self.proxies:
            return None
        proxy = self.proxies[self.current]
        self.current = (self.current + 1) % len(self.proxies)
        return {"http": f"http://{proxy}", "https": f"http://{proxy}"}
    
    def test_proxy(self, proxy):
        try:
            r = requests.get("http://httpbin.org/ip", proxies=proxy, timeout=5)
            return r.status_code == 200
        except:
            return False
    
    def rotate(self):
        """Rotate to next working proxy"""
        attempts = 0
        while attempts < len(self.proxies):
            proxy = self.get_proxy()
            if self.test_proxy(proxy):
                return proxy
            attempts += 1
        return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--test", action="store_true", help="Test proxy rotation")
    args = parser.parse_args()
    
    engine = ProxyEngine()
    engine.load_proxies()
    
    if args.test:
        for i in range(5):
            proxy = engine.rotate()
            if proxy:
                print(f"[+] Proxy {i+1}: {proxy}")
            else:
                print("[-] No working proxy found")
            time.sleep(1)

if __name__ == "__main__":
    main()
