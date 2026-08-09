#!/usr/bin/env python3
import requests, argparse, json, time

class SatelliteRecon:
    def __init__(self, lat, lon):
        self.lat, self.lon = lat, lon

    def get_elevation(self):
        try:
            r = requests.get(f"https://api.open-elevation.com/api/v1/lookup?locations={self.lat},{self.lon}", timeout=10)
            return r.json().get('results', [{}])[0].get('elevation', 0) if r.status_code == 200 else 0
        except: return 0

    def get_weather(self):
        try:
            r = requests.get(f"https://api.open-meteo.com/v1/forecast?latitude={self.lat}&longitude={self.lon}&current_weather=true", timeout=10)
            return r.json().get('current_weather', {}) if r.status_code == 200 else {}
        except: return {}

    def scan(self):
        print(f"\n[+] Satellite Recon: {self.lat}, {self.lon}")
        elev = self.get_elevation()
        print(f"[+] Elevation: {elev}m")
        w = self.get_weather()
        if w:
            print(f"[+] Temp: {w.get('temperature')}°C, Wind: {w.get('windspeed')} km/h")
        map_url = f"https://www.openstreetmap.org/?mlat={self.lat}&mlon={self.lon}&zoom=12"
        print(f"[+] Map: {map_url}")
        with open(f"satellite_{self.lat}_{self.lon}.json", "w") as f:
            json.dump({"lat": self.lat, "lon": self.lon, "elevation": elev, "weather": w, "map": map_url}, f, indent=2)
        print(f"[+] Saved to satellite_{self.lat}_{self.lon}.json")

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--lat", type=float, required=True)
    p.add_argument("--lon", type=float, required=True)
    args = p.parse_args()
    SatelliteRecon(args.lat, args.lon).scan()
