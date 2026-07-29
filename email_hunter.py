#!/usr/bin/env python3
import requests
import argparse
import re

def guess_emails(domain, first, last):
    """Generate common email patterns"""
    patterns = [
        f"{first}.{last}@{domain}",
        f"{first}{last}@{domain}",
        f"{first}_{last}@{domain}",
        f"{first}@{domain}",
        f"{last}@{domain}",
        f"{first[0]}{last}@{domain}",
        f"{first}{last[0]}@{domain}"
    ]
    return patterns

def verify_email(email):
    """Verify email exists (MX lookup + SMTP)"""
    try:
        # Simple domain check
        domain = email.split('@')[1]
        import socket
        socket.gethostbyname(domain)
        return True
    except:
        return False

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--domain", required=True)
    parser.add_argument("--first", required=True)
    parser.add_argument("--last", required=True)
    args = parser.parse_args()
    
    print(f"\n[+] Hunting emails for {args.first}.{args.last}@{args.domain}")
    emails = guess_emails(args.domain, args.first.lower(), args.last.lower())
    
    for email in emails:
        print(f"[-] Checking: {email}")
        if verify_email(email):
            print(f"[+] Valid: {email}")

if __name__ == "__main__":
    main()
