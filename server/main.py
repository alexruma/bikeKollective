# Follow these steps
# https://cloud.google.com/firestore/docs/quickstart-servers
# Step 1 Key path for client_secrets.json
# Step 2 Add sever client library to your app
# Test routes should work after that

import json
from flask import Flask, render_template, request, session, redirect, Blueprint
from google.cloud import firestore
from google.cloud import language
import os
import locations

app = Flask(__name__)
app.register_blueprint(locations.bp)

db = firestore.Client(project='bikekollective-467')

# Sample data to test firestore
@app.route('/')
def index():
    print(db.collection)
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
    user_docs = users_ref.stream()

    bikes_ref = db.collection(u'bikes')
    bikes_docs = bikes_ref.stream()

    user_list = []
    bikes_list = []

    for doc in user_docs:
        user_list.append(doc.to_dict())
        print(f'{doc.id}=>{doc.to_dict()}')
    
    for doc in bikes_docs:
        bikes_list.append(doc.to_dict())
        print(f'{doc.id}=>{doc.to_dict()}')

    return render_template('readData.html',
    context = {"users": user_list, "bikes" : bikes_list}
    )


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)
