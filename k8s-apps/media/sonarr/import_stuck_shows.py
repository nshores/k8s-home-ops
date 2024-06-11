import requests
import json
import time

# Configuration
SONARR_URL = 'https://sonarr.nickshores.net'
API_KEY = 'xxx'

def get_queued_items():
    url = f"{SONARR_URL}/api/v3/queue"
    headers = {'X-Api-Key': API_KEY}
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    else:
        print("Failed to fetch data:", response.status_code)
        return None

def import_queue_item(folder,downloadId,serisId,seasonNumber):
    url = f"{SONARR_URL}/api/v3/manualimport/"
    headers = {'X-Api-Key': API_KEY}
    response = requests.get(url, headers=headers, params=params)
    params = {
    'folder': folder,
    'downloadId': downloadId,
    'seriesId': seriesId,
    'seasonNumber': seasonNumber
    }
    if response.status_code == 200:
        return response.json()
    else:
        print("Failed to fetch data:", response.status_code)
        return None

def main():
        queued_items = get_queued_items()
        if queued_items:
            for item in queued_items['records']:
                #only find stuck pending import items
                if item['trackedDownloadState'] == "importPending" and item['trackedDownloadStatus'] == "warning":
                    print(f"{item['title']} is stuck")
                    print(f"importing {item['title']}")
                    import_queue_item(item['outputPath'],item['downloadId'],item['seriesId'],item['seasonNumber'])
        print("no stuck queue items")


if __name__ == "__main__":
    main()


