from flask import Flask, send_file
from flask import request
from datetime import datetime
from zoneinfo import ZoneInfo
from prometheus_flask_exporter import PrometheusMetrics

app = Flask(__name__)
metrics = PrometheusMetrics(app, export_defaults=False)

metrics.info('app_info', 'ADC App', version='1.0.0')

gandalf_counter = metrics.counter(
    'gandalf_requests_total', 'Total number of requests to /gandalf uri'
)

colombo_counter = metrics.counter(
    'colombo_requests_total', 'Total number of requests to /colombo uri'
)

@app.route("/")
def root():
  return {
    "message": "Speak, friend, and enter.",
    "available_endpoints": ["/status", "/gandalf", "/colombo"]
  }, 200

@app.route("/status")
def hello_world():
  return {"status": "ok"}, 200

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

@app.route("/gandalf")
@gandalf_counter
def gandalf_shall_pass():
  try:
    return send_file("static/gandalf.jpg"), 200
  except FileNotFoundError:
    return {"error": "Gandalf image not found"}, 404
  
@app.route("/colombo")
@colombo_counter
def colombo_time():
    now = datetime.now(ZoneInfo("Asia/Colombo"))
    return {
      "current_time": now.strftime("%d-%m-%Y %H:%M:%S"),
      "timezone" : "Asia/Colombo"
      }, 200