#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
StarHunt v2.0 - OSINT Username Search Engine
Superior to Sherlock - covers 50+ platforms with zero API keys
"""

import sys
import json
import time
import requests
import argparse
from concurrent.futures import ThreadPoolExecutor, as_completed
from urllib.parse import quote_plus

# ==================== PLATFORM DEFINITIONS ====================
PLATFORMS = {
    "tiktok": {
        "url": "https://www.tiktok.com/@{username}",
        "check": "text/html",
        "positive": "could not be found",
        "negative": "user-content"
    },
    "instagram": {
        "url": "https://www.instagram.com/{username}/",
        "check": "text/html",
        "positive": "Page Not Found",
        "negative": "profile-pic"
    },
    "twitter": {
        "url": "https://twitter.com/{username}",
        "check": "text/html",
        "positive": "This account doesn’t exist",
        "negative": "profile"
    },
    "youtube": {
        "url": "https://www.youtube.com/@{username}",
        "check": "text/html",
        "positive": "404 Not Found",
        "negative": "channel"
    },
    "facebook": {
        "url": "https://www.facebook.com/{username}",
        "check": "text/html",
        "positive": "This content isn't available",
        "negative": "profile"
    },
    "github": {
        "url": "https://github.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "repo"
    },
    "reddit": {
        "url": "https://www.reddit.com/user/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "profile"
    },
    "pinterest": {
        "url": "https://www.pinterest.com/{username}/",
        "check": "text/html",
        "positive": "Sorry, we couldn't find",
        "negative": "pin"
    },
    "twitch": {
        "url": "https://www.twitch.tv/{username}",
        "check": "text/html",
        "positive": "Sorry. Unless you’ve got a time machine",
        "negative": "channel"
    },
    "spotify": {
        "url": "https://open.spotify.com/user/{username}",
        "check": "text/html",
        "positive": "Not Found",
        "negative": "playlist"
    },
    "telegram": {
        "url": "https://t.me/{username}",
        "check": "text/html",
        "positive": "Sorry, this username doesn't exist",
        "negative": "tgme_page_title"
    },
    "discord": {
        "url": "https://discord.com/users/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "user"
    },
    "snapchat": {
        "url": "https://www.snapchat.com/add/{username}",
        "check": "text/html",
        "positive": "Sorry, we couldn't find",
        "negative": "bitmoji"
    },
    "whatsapp": {
        "url": "https://wa.me/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "WhatsApp"
    },
    "signal": {
        "url": "https://signal.me/#p/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "signal"
    },
    "wechat": {
        "url": "https://weixin.qq.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "wechat"
    },
    "kik": {
        "url": "https://www.kik.com/{username}/",
        "check": "text/html",
        "positive": "Sorry, we couldn't find",
        "negative": "profile"
    },
    "tumblr": {
        "url": "https://{username}.tumblr.com/",
        "check": "text/html",
        "positive": "There's nothing here",
        "negative": "blog"
    },
    "vimeo": {
        "url": "https://vimeo.com/{username}",
        "check": "text/html",
        "positive": "We couldn't find that page",
        "negative": "video"
    },
    "dailymotion": {
        "url": "https://www.dailymotion.com/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "video"
    },
    "flickr": {
        "url": "https://www.flickr.com/people/{username}/",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "photo"
    },
    "deviantart": {
        "url": "https://www.deviantart.com/{username}",
        "check": "text/html",
        "positive": "We couldn't find that page",
        "negative": "art"
    },
    "behance": {
        "url": "https://www.behance.net/{username}",
        "check": "text/html",
        "positive": "We couldn't find that page",
        "negative": "project"
    },
    "dribbble": {
        "url": "https://dribbble.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "shot"
    },
    "soundcloud": {
        "url": "https://soundcloud.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "tracks"
    },
    "mixcloud": {
        "url": "https://www.mixcloud.com/{username}/",
        "check": "text/html",
        "positive": "404",
        "negative": "cloud"
    },
    "bandcamp": {
        "url": "https://{username}.bandcamp.com/",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "album"
    },
    "reverbnation": {
        "url": "https://www.reverbnation.com/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "artist"
    },
    "patreon": {
        "url": "https://www.patreon.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "member"
    },
    "substack": {
        "url": "https://{username}.substack.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "posts"
    },
    "medium": {
        "url": "https://medium.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "story"
    },
    "hashnode": {
        "url": "https://{username}.hashnode.dev/",
        "check": "text/html",
        "positive": "404",
        "negative": "blog"
    },
    "devto": {
        "url": "https://dev.to/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "post"
    },
    "quora": {
        "url": "https://www.quora.com/profile/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "answer"
    },
    "stackoverflow": {
        "url": "https://stackoverflow.com/users/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "user"
    },
    "hackernews": {
        "url": "https://news.ycombinator.com/user?id={username}",
        "check": "text/html",
        "positive": "No such user",
        "negative": "user"
    },
    "producthunt": {
        "url": "https://www.producthunt.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "product"
    },
    "indiehackers": {
        "url": "https://www.indiehackers.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "post"
    },
    "newsycombinator": {
        "url": "https://news.ycombinator.com/user?id={username}",
        "check": "text/html",
        "positive": "No such user",
        "negative": "user"
    },
    "keybase": {
        "url": "https://keybase.io/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "gravatar": {
        "url": "https://en.gravatar.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "wordpress": {
        "url": "https://{username}.wordpress.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "post"
    },
    "blogger": {
        "url": "https://{username}.blogger.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "post"
    },
    "wix": {
        "url": "https://{username}.wixsite.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "site"
    },
    "weebly": {
        "url": "https://{username}.weebly.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "site"
    },
    "squarespace": {
        "url": "https://{username}.squarespace.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "site"
    },
    "googleplus": {
        "url": "https://plus.google.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "myspace": {
        "url": "https://myspace.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "badoo": {
        "url": "https://badoo.com/en/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "tinder": {
        "url": "https://www.tinder.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "grindr": {
        "url": "https://grindr.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "hinge": {
        "url": "https://hinge.co/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "okcupid": {
        "url": "https://www.okcupid.com/profile/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "plentyoffish": {
        "url": "https://www.pof.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "match": {
        "url": "https://www.match.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    #added 50 more by solez
    "threads": {
        "url": "https://www.threads.net/@{username}",
        "check": "text/html",
        "positive": "Sorry, this page isn't available",
        "negative": "profile"
    },
    "mastodon": {
        "url": "https://mastodon.social/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "vk": {
        "url": "https://vk.com/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "profile"
    },
    "okru": {
        "url": "https://ok.ru/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "linkedin": {
        "url": "https://www.linkedin.com/in/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "profile"
    },
    "xing": {
        "url": "https://www.xing.com/profile/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "ello": {
        "url": "https://ello.co/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "vero": {
        "url": "https://vero.co/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "foursquare": {
        "url": "https://foursquare.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "yelp": {
        "url": "https://www.yelp.com/user_details?userid={username}",
        "check": "text/html",
        "positive": "Page Not Found",
        "negative": "profile"
    },
    "tripadvisor": {
        "url": "https://www.tripadvisor.com/members/{username}",
        "check": "text/html",
        "positive": "Page Not Found",
        "negative": "profile"
    },
    "letterboxd": {
        "url": "https://letterboxd.com/{username}/",
        "check": "text/html",
        "positive": "404",
        "negative": "films"
    },
    "goodreads": {
        "url": "https://www.goodreads.com/{username}",
        "check": "text/html",
        "positive": "Page not found",
        "negative": "shelf"
    },
    "anilist": {
        "url": "https://anilist.co/user/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "myanimelist": {
        "url": "https://myanimelist.net/profile/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "steam": {
        "url": "https://steamcommunity.com/id/{username}",
        "check": "text/html",
        "positive": "The specified profile could not be found",
        "negative": "profile"
    },
    "roblox": {
        "url": "https://www.roblox.com/user.aspx?username={username}",
        "check": "text/html",
        "positive": "Page cannot be found",
        "negative": "profile"
    },
    "itchio": {
        "url": "https://{username}.itch.io/",
        "check": "text/html",
        "positive": "404",
        "negative": "game"
    },
    "kaggle": {
        "url": "https://www.kaggle.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "notebook"
    },
    "replit": {
        "url": "https://replit.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "repl"
    },
    "codepen": {
        "url": "https://codepen.io/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "pen"
    },
    "gitlab": {
        "url": "https://gitlab.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "bitbucket": {
        "url": "https://bitbucket.org/{username}/",
        "check": "text/html",
        "positive": "404",
        "negative": "repo"
    },
    "npm": {
        "url": "https://www.npmjs.com/~{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "package"
    },
    "pypi": {
        "url": "https://pypi.org/user/{username}/",
        "check": "text/html",
        "positive": "404",
        "negative": "package"
    },
    "dockerhub": {
        "url": "https://hub.docker.com/u/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "repository"
    },
    "trello": {
        "url": "https://trello.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "board"
    },
    "notion": {
        "url": "https://www.notion.so/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "page"
    },
    "figma": {
        "url": "https://www.figma.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "500px": {
        "url": "https://500px.com/p/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "photo"
    },
    "unsplash": {
        "url": "https://unsplash.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "photo"
    },
    "artstation": {
        "url": "https://www.artstation.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "artwork"
    },
    "newgrounds": {
        "url": "https://{username}.newgrounds.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "lastfm": {
        "url": "https://www.last.fm/user/{username}",
        "check": "text/html",
        "positive": "Page Not Found",
        "negative": "scrobble"
    },
    "discogs": {
        "url": "https://www.discogs.com/user/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "collection"
    },
    "vsco": {
        "url": "https://vsco.co/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "gallery"
    },
    "clubhouse": {
        "url": "https://www.clubhouse.com/@{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "bereal": {
        "url": "https://bere.al/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "lemmy": {
        "url": "https://lemmy.world/u/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "kofi": {
        "url": "https://ko-fi.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "support"
    },
    "buymeacoffee": {
        "url": "https://www.buymeacoffee.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "supporters"
    },
    "gumroad": {
        "url": "https://{username}.gumroad.com/",
        "check": "text/html",
        "positive": "404",
        "negative": "product"
    },
    "etsy": {
        "url": "https://www.etsy.com/shop/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "shop"
    },
    "venmo": {
        "url": "https://venmo.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "cashapp": {
        "url": "https://cash.app/${username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "cameo": {
        "url": "https://www.cameo.com/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "linktree": {
        "url": "https://linktr.ee/{username}",
        "check": "text/html",
        "positive": "This link doesn't exist",
        "negative": "profile"
    },
    "carrd": {
        "url": "https://{username}.carrd.co/",
        "check": "text/html",
        "positive": "404",
        "negative": "site"
    },
    "aboutme": {
        "url": "https://about.me/{username}",
        "check": "text/html",
        "positive": "404",
        "negative": "profile"
    },
    "xbox": {
        "url": "https://account.xbox.com/en-us/profile?gamertag={username}",
        "check": "text/html",
        "positive": "404",
        "negative": "gamertag"
    }
}

# ==================== CORE ENGINE ====================
class StarHunt:
    def __init__(self, username, timeout=10, threads=20):
        self.username = username
        self.timeout = timeout
        self.threads = threads
        self.results = {}
        self.session = requests.Session()
        self.session.headers.update({
            "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.5",
            "Accept-Encoding": "gzip, deflate, br",
            "Connection": "keep-alive",
            "Upgrade-Insecure-Requests": "1",
            "Sec-Fetch-Dest": "document",
            "Sec-Fetch-Mode": "navigate",
            "Sec-Fetch-Site": "none",
            "Sec-Fetch-User": "?1"
        })

    def check_platform(self, platform, data):
        """Check a single platform for username existence"""
        url = data["url"].format(username=self.username)
        try:
            resp = self.session.get(url, timeout=self.timeout, allow_redirects=True)
            status = resp.status_code
            content = resp.text.lower()

            # Check for positive indicators (account doesn't exist)
            positive = data.get("positive", "").lower()
            if positive and positive in content:
                return (platform, False, status, "Not found")
            
            # Check for negative indicators (account exists)
            negative = data.get("negative", "").lower()
            if negative and negative in content:
                return (platform, True, status, "Found")
            
            # Fallback: status code based
            if status == 200:
                return (platform, True, status, "Found")
            elif status == 404:
                return (platform, False, status, "Not found")
            else:
                return (platform, False, status, f"Unknown ({status})")
                
        except requests.exceptions.Timeout:
            return (platform, False, 0, "Timeout")
        except requests.exceptions.ConnectionError:
            return (platform, False, 0, "Connection error")
        except Exception as e:
            return (platform, False, 0, f"Error: {str(e)[:30]}")

    def scan(self):
        """Run the scan with threading"""
        print(f"\n[+] StarHunt v2.0 - Scanning username: {self.username}")
        print(f"[+] Platforms: {len(PLATFORMS)} | Threads: {self.threads}\n")
        
        with ThreadPoolExecutor(max_workers=self.threads) as executor:
            futures = {
                executor.submit(self.check_platform, platform, data): platform
                for platform, data in PLATFORMS.items()
            }
            
            for future in as_completed(futures):
                platform, found, status, message = future.result()
                self.results[platform] = {
                    "found": found,
                    "status": status,
                    "message": message
                }
                
                # Live output
                icon = "✅" if found else "❌"
                print(f"{icon} {platform:15} | {message}")

    def display_results(self):
        """Display formatted results"""
        print("\n" + "="*60)
        print(f"🔍 STARHUNT RESULTS - {self.username}")
        print("="*60)
        
        found = []
        not_found = []
        
        for platform, data in self.results.items():
            if data["found"]:
                found.append(platform)
            else:
                not_found.append(platform)
        
        print(f"\n✅ FOUND on {len(found)} platforms:")
        for p in sorted(found):
            print(f"  • {p}")
        
        print(f"\n❌ NOT FOUND on {len(not_found)} platforms:")
        for p in sorted(not_found)[:20]:  # Limit display
            print(f"  • {p}")
        if len(not_found) > 20:
            print(f"  ... and {len(not_found)-20} more")
        
        # Save results to file
        with open(f"starhunt_{self.username}.json", "w") as f:
            json.dump(self.results, f, indent=2)
        print(f"\n[+] Results saved to: starhunt_{self.username}.json")
        
        # Generate clickable URLs
        with open(f"starhunt_{self.username}_urls.txt", "w") as f:
            for platform, data in self.results.items():
                if data["found"]:
                    url = PLATFORMS[platform]["url"].format(username=self.username)
                    f.write(f"{platform}: {url}\n")
        print(f"[+] URLs saved to: starhunt_{self.username}_urls.txt")

def main():
    parser = argparse.ArgumentParser(description="StarHunt - OSINT Username Search")
    parser.add_argument("username", help="Username to search")
    parser.add_argument("--threads", type=int, default=20, help="Threads (default: 20)")
    parser.add_argument("--timeout", type=int, default=10, help="Timeout in seconds (default: 10)")
    parser.add_argument("--output", "-o", help="Output file prefix")
    
    args = parser.parse_args()
    
    hunter = StarHunt(args.username, args.timeout, args.threads)
    hunter.scan()
    hunter.display_results()

if __name__ == "__main__":
    main()
