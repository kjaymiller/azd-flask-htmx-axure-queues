from flask import Flask
from azure.storage.queue import QueueClient
import os

app = Flask(__name__)

queue = QueueClient.from_connection_string(
        conn_str=os.environ.get('AZURE_STORAGE_CONNECTION_STRING'),
        queue_name=os.environ.get('AZURE_STORAGE_QUEUE_NAME'),
        )

try:
    queue.create_queue()
except:
    pass

@app.route('/')
def hello_world():
    return "Hello World!"