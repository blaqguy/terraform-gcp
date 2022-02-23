#!/bin/bash

curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
source add-google-cloud-ops-agent-repo.sh --also-install

apt update -y

apt install python3-pip -y

pip3 install flask

touch /opt/helloworld.py

cat << EOF > /opt/helloworld.py
import sqlite3
from sqlite3 import Error
from flask import Flask
from flask import jsonify

def create_connection(path):
    connection = None
    try:
        connection = sqlite3.connect(path)
        print("Connection to SQLite DB successful")
    except Error as e:
        print(f"The error '{e}' occurred")

    return connection

connection = create_connection("helloworld.sqlite")

cursor = connection.cursor()

cursor.execute("CREATE TABLE helloworld (messageid INTEGER PRIMARY KEY AUTOINCREMENT, message TEXT)")

cursor.execute("""INSERT INTO helloworld (message) VALUES ("Hello World!")""")
connection.commit()

cursor.execute("""SELECT message FROM helloworld""")
records = cursor.fetchall()

app = Flask(__name__)

@app.route('/')
def index():
    return jsonify(records)

app.run(host='0.0.0.0', port=80)
EOF

sudo chmod +x /opt/helloworld.py
python3 /opt/helloworld.py
