from connexion import NoContent
from service.registry import Images

image=Images()

def get():
    return image.get_all()

def put():
    return image.get_all()
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
