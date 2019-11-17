from Blood import *


# this class should be deprecated
class BloodFilter():
    def __init__(self):
        raise DeprecationWarning("shouldn't be using this class")
        self.conditions = []
        self._filters = []

    # add a conjunctive condition
    # condition is a function that takes blood as argument
    # and returns True or False to indicate whether this bag 
    # of blood satisfies this condition.
    def add_condition(self, condition):
        self.conditions.append(condition)

    # check if blood satisfies all conditions
    def _check(self, blood: Blood) -> bool:
        for c in self.conditions:
            if not c(blood):
                return False
        return True

    def filter(self, bloods: list) -> list:
        res = []
        for blood in bloods:
            if self._check(blood):
                res.append(blood)
        return res



# class BloodToSendFilter(BloodFilter):
#     def __init__(self, blood_type: str = None):
#         self.__init__2()
#         if blood_type is not None:
#             self.add_condition(lambda blood: blood.type == blood_type)

#     def __init__2(self):
#         super().__init__()
#         self.add_condition(lambda blood: not blood.is_expired())
#         self.add_condition(lambda blood: blood.is_good_blood())
#         self.add_condition(lambda blood: blood.state == BloodState.IN_INVENTORY)


# I wrote these functions so that they are easy to verify using dafny

def filter_blood_by_type(bloods: list, blood_type: str) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.type == blood_type:
            res.append(blood)
    return res

def filter_blood_by_id(bloods: list, blood_id: str) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.id == blood_id:
            res.append(blood)
    return res

def filter_blood_by_state(bloods: list, blood_state: int) -> list:
    if type(blood_state) != int:
        raise ValueError("blood_state must be int")
    res = []
    blood: Blood
    for blood in bloods:
        if blood.state.value == blood_state:
            res.append(blood)
    return res

def filter_blood_by_test_state(bloods: list, blood_test_state: int) -> list:
    if type(blood_test_state) != int:
        raise ValueError("blood_test_state must be int")
    res = []
    blood: Blood
    for blood in bloods:
        if blood.test_state.value == blood_test_state:
            res.append(blood)
    return res

def filter_not_expired_blood(bloods: list, curr_time: int) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.use_by > curr_time:
            res.append(blood)
    return res

def filter_expired_blood(bloods: list, curr_time: int) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.use_by <= curr_time:
            res.append(blood)
    return res

def filter_good_blood(bloods: list) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.test_state == BloodTestState.GOOD:    # == 2
            res.append(blood)
    return res

def filter_in_inventory_blood(bloods: list) -> list:
    res = []
    blood: Blood
    for blood in bloods:
        if blood.state == BloodState.IN_INVENTORY:     # == 1
            res.append(blood)
    return res

def filter_blood_to_send(bloods: list, curr_time: int) -> list:
    bloods = filter_not_expired_blood(bloods, curr_time)
    bloods = filter_blood_by_state(bloods, BloodState.IN_INVENTORY.value)
    bloods = filter_blood_by_test_state(bloods, BloodTestState.GOOD.value)
    return bloods
