# Follow these steps
# https://cloud.google.com/firestore/docs/quickstart-servers
# Step 1 Key path for client_secrets.json
# Step 2 Add sever client library to your app
# Test routes should work after that

import json
import flask
from google.cloud import firestore

app = flask.Flask(__name__)

db = firestore.Client(project='bikekollective-467')

# Sample data to test firestore
@app.route('/')
def index():
    return "TEST", 200


@app.route('/testadd')
def adddata():
    doc_ref = db.collection(u'users').document(u'lovelace')
    doc_ref.set({
        u'first': u'Ada',
        u'last': u'Lovelace',
        u'born': 1815
    })
    return "", 200


@app.route('/readdata')
def readdata():
    users_ref = db.collection(u'users')
    docs = users_ref.stream()

    for doc in docs:
        print(f'{doc.id}=>{doc.to_dict()}')

    return "", 200


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)
