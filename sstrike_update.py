import requests

url = 'https://raw.githubusercontent.com/Vitalij3703/starstrike/starstrike.py'
response = requests.get(url)
response.raise_for_status()
content = response.text
f = ""
try:f = open("plugins/starstrike.py", "wt")
except FileNotFoundError:f = open("plugins/starstrike.py", "wt")
finally:f.write(content)
