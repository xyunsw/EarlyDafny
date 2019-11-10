from Inventory import *
from Blood import *
import sys


def dbgprint(*args, **kwargs):
    print(*args, **kwargs, file=sys.stderr)

class BackendApi():
    def __init__(self):
        self._inventory = Inventory()
    
    def add_blood(self, data: dict):
        res = self._inventory.add_blood(data['donor_name'], data['donor_id'])
        dbgprint(f"add blood: {data}")
        return {
            "success": True
        }

    def request_blood(self, data: dict):
        res = self._inventory.request_blood(data['n_bags'], data['blood_type'])
        dbgprint(f"request blood: {data}")
        if res is None:
            return {"success": False, "msg": "Invalid request"}
        return {"success": True, "blood": res}

    def get_blood_public_info(self):
        res = self._inventory.get_blood_public_info()
        return {"success": True, "blood_types": res}

    def get_blood_by_id(self, data: dict):
        id = int(data['id'])
        try:
            blood = self._inventory.get_blood_by_id(id)
        except:
            return {"success": False, "msg": f"blood of id {id} not found"}
        info = {"success": True}
        info['use_by'] = blood.use_by
        info['state'] = blood.state
        info['test_state'] = blood.test_state
        info['feedback'] = blood.feedback
        info['type'] = blood.type
        return info

    def update_blood(self, data: dict):
        id = int(data['id'])
        # fixme
        new_blood: Blood = Blood(None)
        new_blood.use_by = data['use_by']
        new_blood.state = data['state']
        new_blood.test_state = data['test_state']
        new_blood.feedback = data['feedback']
        new_blood.type = data['type']
        res = self._inventory.update_blood(id, new_blood)
        return {"success": True}



