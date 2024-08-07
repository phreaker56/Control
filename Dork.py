import requests
from bs4 import BeautifulSoup
import urllib.parse

def search_dork(dork):
    query = urllib.parse.quote(dork)
    url = f"https://www.google.com/search?q={query}"
    headers = {
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
    }

    try:
        response = requests.get(url, headers=headers)
        response.raise_for_status()
    except requests.exceptions.HTTPError as err:
        print(f"HTTP error occurred: {err}")
        return
    except Exception as err:
        print(f"Other error occurred: {err}")
        return

    soup = BeautifulSoup(response.text, 'html.parser')
    results = []
    for g in soup.find_all('div', class_='g'):
        link = g.find('a')
        if link and 'href' in link.attrs:
            title = g.find('h3').text if g.find('h3') else 'No Title'
            results.append((title, link.attrs['href']))

    if results:
        for title, link in results:
            print(f"Title: {title}\nURL: {link}\n")
    else:
        print("No results found.")

dorks = [
    'intext:"powered by Adyen" "buy toys" inurl:checkout',
    'intext:"powered by Adyen" "juguetes" inurl:checkout',
    'intext:"powered by Adyen" "toy store" inurl:cart'
]

for dork in dorks:
    print(f"Results for dork: {dork}")
    search_dork(dork)
    print("\n" + "="*50 + "\n")
