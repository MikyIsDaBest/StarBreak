#!/usr/bin/env python3
import requests
import hashlib
import argparse

def check_breach(email):
    """Check if email appears in known breaches using HaveIBeenPwned"""
    try:
        r = requests.get(f"https://haveibeenpwned.com/api/v3/breachedaccount/{email}", 
                        headers={"hibp-api-key": "your-key-here"})
        if r.status_code == 200:
            return r.json()
        elif r.status_code == 404:
            return []
        else:
            return []
    except:
        return []

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--email", required=True)
    args = parser.parse_args()
    
    print(f"\n[+] Checking breaches for {args.email}")
    breaches = check_breach(args.email)
    
    if breaches:
        print(f"[!] Found in {len(breaches)} breaches:")
        for b in breaches:
            print(f"  - {b['Name']} ({b['BreachDate']})")
    else:
        print("[+] No breaches found!")

if __name__ == "__main__":
    main()
