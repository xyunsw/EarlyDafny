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

    def start_level_checking(self):
        self._inventory.start_checking()
    
    def add_blood(self, data: dict):
        if data['source'] == "Red Cross":
            ext = {"use_by": data['use_by'], "blood_type": data['blood_type']}
        else:
            ext = {}
        if data['donor_name'] == "" or data['donor_id'] == "":
            return {"success": False, "msg": "Please enter donor's info"}
        res = self._inventory.add_blood(data['donor_name'], data['donor_id'], data['source'], **ext)
        # dbgprint(f"add blood: {data}")
        return {
            "success": True,
            "id": res
        }

    def request_blood(self, data: dict):
        print(f"request_blood: we are using inventory {self}")
        try:
            n_bags = int(data['n_bags'])
            if n_bags <= 0:
                raise ValueError()
        except:
            return {"success": False, "msg": "Invalid amount"}
        if data['org']['name'] == "" or data['org']['address'] == "" or data['org']['phone'] == "":
            return {"success": False, "msg": "Please complete organization information"}
        org = Organization(data['org']['name'], data['org']['address'], data['org']['phone'])
        res = self._inventory.request_blood(n_bags, data['blood_type'], org)
        dbgprint(f"request blood: {data}")
        if res is None:
            return {"success": False, "msg": "Insufficient blood"}
        return {"success": True, "blood": res}
    
    def donation_history(self, data: dict):
        if data['donor_name'] == "" or data['donor_id'] == "":
            return {"success": False, "msg": "Please enter donor's info"}
        hist = self._inventory.get_blood_by_donor(data['donor_name'], data['donor_id'])
        return {"success": True, "history": hist}

    def blood_to_dict(self, blood: Blood) -> dict:
        info = {}
        info['donor_name'] = blood.donor.name
        info['donor_id'] = blood.donor.id
        info['add_time'] = blood.add_time
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
        id = int(data['id'])
        new_blood: Blood = self._inventory.get_blood_by_id(id)
        new_blood.use_by = int(data['use_by'])
        new_blood.state = int(data['state'])
        new_blood.test_state = int(data['test_state'])
        new_blood.feedback = data['feedback']
        new_blood.type = data['type']
        res = self._inventory.update_blood(id, new_blood)
        return {"success": True}

    def request_to_dict(self, req: Request) -> dict:
        info = {}
        bloods = []
        for blood in req.bloods:
            bloods.append(self.blood_to_dict(blood))
        b: Blood = req.bloods[0]
        info['type'] = b.type
        info['time'] = req.time
        info['n_bags'] = req.n_bags
        info['bloods'] = bloods
        info['id'] = req.id
        org = {"name": req.org.name, "address": req.org.address, "phone": req.org.phone}
        info['org'] = org
        return info

    def get_request_by_id(self, data: dict) -> dict:
        id = int(data['id'])
        try:
            req = self._inventory.get_request_by_id(id)
        except:
            return {"success": False, "msg": f"request of id {id} not found"}
        info = {"success": True}
        info.update(self.request_to_dict(req))
        return info

    def get_request_list(self) -> dict:
        res = self._inventory.get_request_list()
        reqs = [self.request_to_dict(req) for req in res]
        info = {"success": True, "requests": reqs}
        return info

    def get_bloods_by_conditions(self, opt: dict) -> dict:
        res = self._inventory.get_bloods_by_conditions(opt)
        bloods = {'success': True}
        size = len(res)
        for i in range(size):
            b: Blood = res[i]
            res[i] = self.blood_to_dict(b)
        bloods['bloods'] = res
        return bloods

    def get_blood_level_by(self, data: dict) -> dict:
        filter = data.get('filter', None)
        if filter == 'BloodToSend':
            bloods = filter_blood_to_send(self._inventory.bloods, int(time.time()))
            res = self._inventory.get_blood_level_by(data['cat'], bloods)
        else:
            res = self._inventory.get_blood_level_by(data['cat'])
        return res
