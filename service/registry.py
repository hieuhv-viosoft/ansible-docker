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
# def Remote(cmd,IP):
#     cmd = '''ssh root@%s '''%(IP)+cmd
#     lines = subprocess.check_output(cmd.split())
#     return '\n'.join(lines)


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
	def init_server(ipmi_user,ipmi_addr,ipmi_pass,mac_addr):
		# sql = "SELECT ID FROM " + 'SERVERS'
		# cur.execute(sql)
		# if cur = "":
		# 	id=
		id = "00000000-0000-0000-0000-000000000001"
		name = "server1"
		ipv4_addr = "172.16.166.34"
		server = Server(id,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr)
		return server

	@staticmethod
	def setup(server):
		os.system('scp deploy_os.sh root@172.17.0.1:/root')
		cmd = 'ssh root@172.17.0.1 bash deploy_os.sh ' + ' ' + server.id + ' ' +  server.name + ' ' + server.ipmi_user + ' ' + server.ipmi_addr + ' ' + server.ipmi_pass + ' ' + server.mac_addr + ' ' + server.ipv4_addr
		# os.system('apt-get -y update')
		# os.system('apt-get install -y openssh-server')
		# os.system('ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""')
		# os.system('apt-get install -y sshpass')
		# os.system('sshpass -p "blueteam11" ssh-copy-id -o StrictHostKeyChecking=no root@172.17.0.1')
		# os.system('scp setup_host.sh root@172.17.0.1:/root')
		# os.system('ssh root@172.17.0.1 '+ cmd)
		os.system(cmd)
