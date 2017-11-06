#!/usr/bin/env python3
import connexion
import datetime
import logging

from flask.ext.cors import CORS

from connexion import NoContent
from connexion.resolver import RestyResolver


logging.basicConfig(level=logging.INFO)
app = connexion.App(__name__)
app.add_api('swagger/swagger.yaml', resolver=RestyResolver('api'))
# set the WSGI application callable to allow using uWSGI:
# uwsgi --http :8080 -w app
CORS(app.app)

if __name__ == '__main__':
	# run our standalone gevent server
	app.run(port=9090, server='gevent')
