import requests
from pathlib import Path
import time
import os
import re

from html.parser import HTMLParser
from urllib.parse import urlparse, parse_qs
import uuid
print(os.environ['HOME'])
print(time.time())
files = []
while len(files) == 0:
    time.sleep(2)
    files = list((Path(os.environ['HOME']) / '.local/share/jupyter/runtime').glob('jpserver*'))

   
latest_kernel = max(files, key=lambda p: p.stat().st_ctime)

class MyHTMLParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.url = None

    def handle_starttag(self, tag, attrs):
        if tag == 'a':
            url = dict(attrs)['href']
            self.url = urlparse(url)

parser = MyHTMLParser()
parser.feed(latest_kernel.read_text())
endpoint = (lambda u: f'{u.scheme}://{u.netloc}')(parser.url)
token = parse_qs(parser.url.query)['token'][0]

headers = {
    'Authorization': f'token {token}',
}

params = (
    (int(time.time() * 1000), ''),
)

data = '{"path": "' + str(uuid.uuid4()) +'","type":"console","name":"MY REPL","kernel":{"name":"python3"}}'

response = requests.post(endpoint + '/api/sessions', headers=headers, params=params, data=data)

print(response.status_code)
print(response.content)
