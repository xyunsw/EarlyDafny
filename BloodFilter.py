from Blood import *

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
