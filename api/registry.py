from connexion import NoContent
from service.registry import Images

image=Images()

def get():
    return image.get_all()

def put(uuid,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr):
    image.setup_server(init_server(uuid,name,ipmi_user,ipmi_addr,ipmi_pass,mac_addr,ipv4_addr))
# def get_user(user_id):
#
#     return account.get_user(user_id)
#
# def put(user_id, user):
# 	return account.add_user(user_id, user)
#
#
# def delete(user_id):
#
# 	return account.delete_user(user_id)
