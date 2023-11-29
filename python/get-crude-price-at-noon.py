import requests
import datetime
import pytz

# Set the URL of the crude oil price API
api_url = "https://www.quandl.com/api/v3/datasets/EIA/PET_RBRTE_D.json"

# Set the API key
api_key = "YOUR_API_KEY"

# Fetch the current time in UTC
now_utc = datetime.datetime.now(pytz.utc)

# Set the server timezone, e.g. 'America/New_York'
server_timezone = pytz.timezone('America/New_York')

# Convert the current UTC time to server's timezone
now = now_utc.astimezone(server_timezone)

# Check if it is around noon (12:00 PM) in the server's timezone
# Adjust the timing window as needed
if now.hour == 12 and 0 <= now.minute <= 5:
    # Send a GET request to the API and store the response
    # Add your API key in the params
    response = requests.get(api_url, params={"api_key": api_key})

    # Check if the request was successful
    if response.status_code == 200:
        # Parse the JSON data from the response
        data = response.json()
        # Print the current crude oil price
        # Ensure the API returned data as acceptable
        if data and 'dataset' in data and 'data' in data['dataset'] and len(data['dataset']['data']) > 0:
            print(f"The current price of crude oil is {data['dataset']['data'][0][1]} USD per barrel.")
        else:
            print("Data is not available in the expected format.")
    else:
        print(f"Failed to fetch crude oil prices. Status code: {response.status_code}")
else:
    print("It is not currently around noon in the server's timezone.")