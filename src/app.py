import logging
from flask import Flask
from azure.storage.queue import QueueClient
import os

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

conn_str = os.environ.get("AZURE_STORAGE_CONNECTION_STRING")
queue_name = os.environ.get("AZURE_STORAGE_QUEUE_NAME")

logging.info("Connecting to queue...")
logging.debug(f"Connection string: {conn_str}")
logging.debug(f"Queue name: {queue_name}")

queue = QueueClient.from_connection_string(
        conn_str=conn_str,
        queue_name=queue_name,
        )

logging.info(f"creating {queue}")

queue.create_queue()
logging.info('Queue created')
    


@app.route('/')
def hello_world():                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
    content = queue.receive_message()
    print(content.content)
    queue.delete_message(content)
    return content.content
