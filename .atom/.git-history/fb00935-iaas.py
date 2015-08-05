"""
Jobs Plugin
"""
from ..auth import requires_groups
from flask import Blueprint, jsonify
import requests
from ..error import Unavailable


API_NAME = "IAAS"


iaas = Blueprint('iaas', __name__, url_prefix='/iaas')
IAAS_URL = 'http://127.0.0.1:3000'


@iaas.route('/quickbuild/<rpmname>', methods=['GET', 'POST'])
@requires_groups('all-access', 'All Access')
def quickbuild(rpmname):
    """
    Contact the IAAS server and make a request to build an image.
    """
    try:
        r = requests.post(IAAS_URL + '/quickbuild/' + rpmname)
    except requests.ConnectionError:
        raise Unavailable
    return jsonify(r.json())


@iaas.route('/builds/<int:build_number>', methods=['GET', 'POST'])
@requires_groups('all-access', 'All Access')
def info(build_number):
    """
    Contact the IAAS server and get info about a build number.
    """
    try:
        r = requests.post(IAAS_URL + '/builds/' + str(build_number))
    except requests.ConnectionError:
        raise Unavailable
    return jsonify(r.json())


@iaas.route('/builds/status/<int:build_number>', methods=['GET', 'POST'])
@requires_groups('all-access', 'All Access')
def status(build_number):
    """
    Contact the IAAS server and get the status of a build number.
    """
    try:
        r = requests.post(IAAS_URL + '/builds/status/' + str(build_number))
    except requests.ConnectionError:
        raise Unavailable
    return jsonify(r.json())


@iaas.route('/builds/stop/<int:build_number>', methods=['GET', 'POST'])
@requires_groups('all-access', 'All Access')
def stop(build_number):
    """
    Contact the IAAS server and stop build number [build_number].
    """
    try:
        r = requests.post(IAAS_URL + '/builds/stop/' + str(build_number))
    except requests.ConnectionError:
        raise Unavailable
    return jsonify(r.json())
