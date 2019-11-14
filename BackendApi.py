from Inventory import *
from Blood import *
from Organization import *
import sys


def dbgprint(*args, **kwargs):
    print(*args, **kwargs, file=sys.stderr)

class BackendApi():
    def __init__(self):
        self._inventory = Inventory()
        print(f"********* we are using inventory {self}")
    
    def add_blood(self, data: dict):
        res = self._inventory.add_blood(data['donor_name'], data['donor_id'])
        dbgprint(f"add blood: {data}")
        return {
            "success": True
        }

    def request_blood(self, data: dict):
        print(f"request_blood: we are using inventory {self}")
        org = Organization(data['org']['name'], data['org']['address'], data['org']['phone'])
        res = self._inventory.request_blood(int(data['n_bags']), data['blood_type'], org)
        dbgprint(f"request blood: {data}")
        if res is None:
            return {"success": False, "msg": "Invalid request"}
        return {"success": True, "blood": res}

    def get_blood_public_info(self):
        res = self._inventory.get_blood_public_info()
        return {"success": True, "blood_types": res}

    def blood_to_dict(self, blood: Blood) -> dict:
        info = {}
        info['use_by'] = blood.use_by
        info['state'] = blood.state.value
        info['test_state'] = blood.test_state.value
        info['feedback'] = blood.feedback
        info['type'] = blood.type
        info['id'] = blood.id
        return info

    def get_blood_by_id(self, data: dict):
        print(f"get_blood_by_id: we are using inventory {self}")
        id = int(data['id'])
        try:
            blood = self._inventory.get_blood_by_id(id)
        except:
            return {"success": False, "msg": f"blood of id {id} not found"}
        info = {"success": True}
        info.update(self.blood_to_dict(blood))
        info['id'] = id

        return info

    def update_blood(self, data: dict):
        print(f"update_blood: we are using inventory {self}")
        id = int(data['id'])
        # fixme
        new_blood: Blood = self._inventory.get_blood_by_id(id)
        new_blood.use_by = int(data['use_by'])
        new_blood.state = int(data['state'])
        new_blood.test_state = int(data['test_state'])
        new_blood.feedback = data['feedback']
        new_blood.type = data['type']
        res = self._inventory.update_blood(id, new_blood)
        return {"success": True}

    def get_request_by_id(self, data: dict) -> dict:
        print(f"get_request_by_id: we are using inventory {self}")
        id = int(data['id'])
        try:
            req = self._inventory.get_request_by_id(id)
        except:
            return {"success": False, "msg": f"request of id {id} not found"}
        info = {"success": True}
        bloods = []
        for blood in req.bloods:
            bloods.append(self.blood_to_dict(blood))
        info['bloods'] = bloods
        info['id'] = id
        org = {"name": req.org.name, "address": req.org.address, "phone": req.org.phone}
        info['org'] = org
        return info


