import datetime
import logging
from flask import request
from connexion import NoContent
import requests
import sqlite3
import subprocess
import os
from service.server import Server

#target = Server()
conn = sqlite3.connect('Images.db')

class Images(object):

	@staticmethod
	def get_all():
		results = []
		sql = "SELECT * FROM " + 'IMAGES'
		cur = conn.cursor()
		cur.execute(sql)
		rows = cur.fetchall()
		# convert sql query result into map
		for row in rows:
			results.append(row)
		return results

	@staticmethod
	def init_server(id,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr):
		server = Server(id,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr)
		return server

	@staticmethod
	def setup(server):
		cmd = 'sh script.sh ' + ' ' + server.id + ' ' +  server.name + ' ' + server.ipmi_user + ' ' + server.ipmi_addr + ' ' + server.ipmi_pass + ' ' + server.mac_addr + ' ' + server.ipv4_addr
		os.system(ssh root@172.17.0.1 cmd)
