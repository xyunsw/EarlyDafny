from Donor import *
from Blood import *


class BloodFilter():
    def __init__(self):
        self.conditions = []

    def add_condition(self, condition):
        self.conditions.append(condition)

    def check(self, blood: Blood) -> bool:
        for c in self.conditions:
            if not c(blood):
                return False
        return True



class BloodToSendFilter(BloodFilter):
    def __init__(self, blood_type: str):
        self.__init__()
        self.add_condition(lambda blood: blood.type == blood_type)

    def __init__(self):
        super().__init__()
        self.add_condition(lambda blood: not blood.is_expired())
        self.add_condition(lambda blood: blood.is_good_blood())
        self.add_condition(lambda blood: blood.state == BloodState.IN_INVENTORY)


class Inventory(object):
    def __init__(self):
        self.bloods = []


    def add_blood(self, donor_name: str, donor_id: str):
        donor = Donor(donor_name, donor_id)
        blood = Blood(donor)
        self.bloods.append(blood)
        

    def request_blood(self, n_bags: int, blood_type: str) -> list:
        bloods = self.filter_blood(BloodToSendFilter(blood_type))
        if n_bags > len(bloods) or n_bags <= 0:
            return None
        bloods_to_send = bloods[0:n_bags]
        self.mark_bloods(bloods_to_send, BloodState.USED)
        return bloods_to_send


    def filter_blood(self, filter: BloodFilter) -> list:
        bloods = []
        for blood in self.bloods:
            if filter.check():
                bloods.append(blood)
        return bloods

    def mark_bloods(self, bloods: list, state: BloodState):
        for blood in self.bloods:
            blood.state = state

    def get_blood_public_info(self) -> dict:
        bloods = self.filter_blood(BloodToSendFilter())
        blood_types = {}
        for blood in bloods:
            type = blood.type
            if blood_types is None:
                blood_types[type] = 1
            else:
                blood_types[type] += 1
        return blood_types


