from connexion import NoContent
from service.registry import Images

image=Images()

def get():
    return image.get_all()

def put(server):
    image.setup(image.init_server(server['id'],server['name'],server['ipmi_user'],server['ipmi_addr'],server['ipmi_pass'],server['mac_addr'],server['ipv4_addr']))
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
