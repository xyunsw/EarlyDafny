from Donor import *
from Blood import *
from Request import *
from Organization import *


class BloodFilter():
    def __init__(self):
        self.conditions = []

    # add a conjunctive condition
    # condition is a function that takes blood as argument
    # and returns True or False to indicate whether this bag 
    # of blood satisfies this condition.
    def add_condition(self, condition):
        self.conditions.append(condition)

    # check if blood satisfies all conditions
    def check(self, blood: Blood) -> bool:
        for c in self.conditions:
            if not c(blood):
                return False
        return True

    def filter(self, bloods: list) -> list:
        res = []
        for blood in bloods:
            if self.check(blood):
                res.append(blood)
        return res



class BloodToSendFilter(BloodFilter):
    def __init__(self, blood_type: str = None):
        self.__init__2()
        if blood_type is not None:
            self.add_condition(lambda blood: blood.type == blood_type)

    def __init__2(self):
        super().__init__()
        self.add_condition(lambda blood: not blood.is_expired())
        self.add_condition(lambda blood: blood.is_good_blood())
        # def func(blood):
        #     print(f"blood state: {blood.state}")
        #     return blood.state == BloodState.IN_INVENTORY
        # self.add_condition(func)
        self.add_condition(lambda blood: blood.state == BloodState.IN_INVENTORY)


class Inventory(object):
    def __init__(self):
        self.bloods = []
        self._requests = []


    def add_blood(self, donor_name: str, donor_id: str):
        donor = Donor(donor_name, donor_id)
        blood = Blood(len(self.bloods), donor)
        print("add blood...")

        self.bloods.append(blood)
        

    def request_blood(self, n_bags: int, blood_type: str, org: Organization) -> list:
        bloods = self.filter_blood(BloodToSendFilter(blood_type))
        if n_bags > len(bloods) or n_bags <= 0:
            return None
        bloods_to_send = bloods[0:n_bags]
        self.mark_bloods(bloods_to_send, BloodState.USED)
        print(f"marking blood: {bloods_to_send}")
        self._requests.append(Request(org, bloods_to_send))
        return bloods_to_send


    def filter_blood(self, filter: BloodFilter) -> list:
        bloods = []
        for blood in self.bloods:
            if filter.check(blood):
                bloods.append(blood)
        return bloods

    def mark_bloods(self, bloods: list, state: BloodState):
        for blood in bloods:
            blood.state = state

    def get_blood_public_info(self) -> dict:
        bloods = self.filter_blood(BloodToSendFilter())
        blood_types = {}
        for blood in bloods:
            type = blood.type
            if blood_types.get(type, None) is None:
                blood_types[type] = 1
            else:
                blood_types[type] += 1
        return blood_types

    def get_blood_by_id(self, id: int) -> Blood:
        print(self.bloods)
        return self.bloods[id]

    def update_blood(self, id: int, new_blood: Blood):
        print(self.bloods)
        self.bloods[id] = new_blood
        new_blood.id = id

    def get_request_by_id(self, id: int) -> Request:
        return self._requests[id]

    # see blood_inventory.html to check what are inside opt
    def get_bloods_by_conditions(self, opt: dict) -> list:
        bf = BloodFilter()
        res = opt.get('id', None)
        # python's variable capture in lambda doesn't seem to work as expected
        if res is not None:
            s1 = res
            bf.add_condition(lambda blood: blood.id == int(s1))
        res = opt.get('type')
        if res is not None:
            s2 = res
            bf.add_condition(lambda blood: blood.type == str(s2))
        res = opt.get('isexpired', None)
        if res is not None:
            bf.add_condition(lambda blood: blood.is_expired())
        res = opt.get('state', None)
        if res is not None:
            #print(f'res is : {res}')
            s3 = int(res)
            bf.add_condition(lambda blood: blood.state.value == int(s3))
        res = opt.get('test_state', None)
        if res is not None:
            s4 = int(res)
            bf.add_condition(lambda blood: blood.test_state.value == int(s4))
        
        bloods: list = bf.filter(self.bloods)

        ascdesc = opt.get('ascdesc', None)
        if ascdesc is None or ascdesc == 'asc':
            reverse = False
        else:
            reverse = True
        # I'm temporarily using build-in sort, but a dafny version
        # needs to be implemented and I will port it to here.
        order_by = opt.get('order_by', None)
        if order_by is not None:
            if order_by == 'use_by':
                bloods.sort(key=lambda blood: blood.use_by, reverse=reverse)
            else:
                bloods.sort(key=lambda blood: blood.add_time, reverse=reverse)
        
        return bloods
        


        

