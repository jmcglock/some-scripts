import requests
import datetime
import pytz
# Set the URL of the crude oil price API
api_url = "https://www.quandl.com/api/v3/datasets/EIA/PET_RBRTE_D.json"
# Set the API key
api_key = "YOUR_API_KEY"
# Fetch the current time
now = datetime.datetime.now(pytz.utc)
# Set the server timezone
server_timezone = pytz.timezone('SERVER_TIMEZONE')
#Check if it is noon in the server's timezone
if now.astimezone(server_timezone).hour == 12 and now.astimezone(server_timezone).minute == 0:
# Send a GET request to the API and store the response
response = requests.get(api_url, params={"api_key": api_key})
# Check if the request was successful
if response.status_code == 200:
# Parse the JSON data from the response
data = response.json()
# Print the current crude oil price
print(f"The current price of crude oil is {data['dataset']['data'][0][1]} USD per barrel.")