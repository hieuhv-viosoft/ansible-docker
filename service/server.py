import logging
import os
import sqlite3
from sqlite3 import Error

class Server:
    def __init__(self,id,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr):
        self.id = id
        self.name = name
        self.ipmi_user = ipmi_user
        self.ipmi_addr = ipmi_addr
        self.ipmi_pass = ipmi_pass
        self.mac_addr  = mac_addr
        self.ipv4_addr = ipv4_addr

    def get_uuid(self):
        return self.uuid

    def get_name(self):
        return self.name

    def get_ipmi_user(self):
        return self.ipmi_user

    def get_ipmi_addr(self):
        return self.ipmi_addr

    def get_ipmi_pass(self):
        return self.ipmi_pass

    def get_mac_addr(self):
        return self.mac_addr

    def get_ipv4_addr(self):
        return self.ipv4_addr

    def set_uuid(self,id):
        self.id = id

    def set_name(self,name):
        self.name = name

    def set_ipmi_user(self,ipmi_user):
        self.ipmi_user = ipmi_user

    def set_ipmi_addr(self,ipmi_addr):
        self.ipmi_addr = ipmi_addr

    def set_ipmi_pass(self,ipmi_pass):
        self.ipmi_pass = ipmi_pass

    def set_mac_addr(self,mac_addr):
        self.mac_addr = mac_addr

    def set_ipv4_addr(self,ipv4_addr):
        self.ipv4_addr = ipv4_addr
