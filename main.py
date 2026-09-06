import os
import socket
from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = os.getenv("APP_NAME", "devops-interview-api")
APP_ENV = os.getenv("APP_ENV", "local")
APP_VERSION = os.getenv("APP_VERSION", "v1")


@app.route("/")
def home():
    return jsonify(
        application=APP_NAME,
        environment=APP_ENV,
        version=APP_VERSION,
        hostname=socket.gethostname(),
        message="DevOps interview project is running"
    )


@app.route("/health")
def health():
    return jsonify(status="healthy"), 200


@app.route("/ready")
def readiness():
    return jsonify(status="ready"), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)