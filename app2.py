from flask import Flask, Response
import requests
import json
import sys
import pandas as pd
import torch
from chronos import ChronosPipeline
 
# create our Flask app
app = Flask(name)
 
# define the Hugging Face model we will use
model_name = "amazon/chronos-t5-tiny"
# modify the process function as necessary
def process(argument):
    url = f"https://api.upshot.xyz/v2/allora/tokens-oracle/token/{argument}"    
    #Coverting the curl call to python
    headers = {
      'accept': 'accept: application/json',
      'x-api-key': 'UP-920fa918502c41d0bd96b8e8',
    }
    
    response = requests.get(url, headers=headers)
    json_response = response.json()
    
    return json_response["data"]["token_id"]

# define our endpoint
@app.route("/inference/<string:block>")
def get_inference(block):
    """Generate inference for given token."""
    try:
        # use a pipeline as a high-level helper
        pipeline = ChronosPipeline.from_pretrained(
            model_name,
            device_map="auto",
            torch_dtype=torch.bfloat16,
        )
    except Exception as e:
        return Response(json.dumps({"pipeline error": str(e)}), status=500, mimetype='application/json')
 

    response_inference = process(argument=block)
    # get the data from Coingecko
    url = "https://api.coingecko.com/api/v3/coins/"
    url += response_inference 
    url += "/market_chart?vs_currency=usd&days=3&interval=daily"
    
    headers = {
        "accept": "application/json",
        "x-cg-demo-api-key": "CG-xDakxFq8GTNnvrBoECi7XEEM" # replace with your API key
    }
 
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        data = response.json()
        df = pd.DataFrame(data["prices"])
        df.columns = ["date", "price"]
        df["date"] = pd.to_datetime(df["date"], unit = "ms")
        df = df[:-1] # removing today's price
        print(df.tail(5))
    else:
        return Response(json.dumps({"Failed to retrieve data from the API": str(response.text)}), 
                        status=response.status_code, 
                        mimetype='application/json')
 
    # define the context and the prediction length
    context = torch.tensor(df["price"])
    prediction_length = 1
 
    try:
        forecast = pipeline.predict(context, prediction_length)  # shape [num_series, num_samples, prediction_length]
        print(forecast[0].mean().item()) # taking the mean of the forecasted prediction
        return Response(str(forecast[0].mean().item()), status=200)
    except Exception as e:
        return Response(json.dumps({"error": str(e)}), status=500, mimetype='application/json')
 
# run our Flask app
if name == 'main':
    app.run(host="0.0.0.0", port=8000, debug=True)
