import json
from flask import Flask, render_template, request, session, redirect, Blueprint, jsonify
from google.cloud import firestore
from google.cloud import language

import os
import locations

bp = Blueprint('locations', __name__, url_prefix='/locations')

db = firestore.Client(project='bikekollective-467')
@bp.route('', methods=['GET'])
def get_all_locations():
    locations = db.collection(u'locations')
    loc_docs = locations.stream()

    location_list = []

    for doc in loc_docs:

        location_list.append(doc.to_dict())
    print(location_list)
    return jsonify(location_list)
