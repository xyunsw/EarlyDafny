from Inventory import *
import sys

inventory = Inventory()

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


