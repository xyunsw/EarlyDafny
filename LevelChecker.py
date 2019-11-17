# from Inventory import *
from Blood import *
from Inventory import *
from BloodFilter import *

class LevelChecker(object):
    # the browser will be stucked if there are too many bags of blood...
    # so I'm going to reduce the critical value
    CRITICAL1 = 200
    CRITICAL2 = 100
    CRITICAL3 = 50
    def __init__(self, inventory):
        self._inventory = inventory

    def check_level(self):
        types = set()
        blood: Blood
        for blood in self._inventory.bloods:
            types.add(blood.type)
        for t in types:
            if t != "":
                res = self.check_level_by_type(t)
                if res == "critical3":
                    self.action_critical3(t)
                if res == "critical2":
                    self.action_critical2(t)
                if res == "critical1":
                    self.action_critical1(t)

    def check_level_by_type(self, blood_type: str):
        bloods = filter_blood_to_send(self._inventory.bloods, int(time.time()))
        bloods = filter_blood_by_type(bloods, blood_type)
        n_bags = len(bloods)
        if (n_bags < self.CRITICAL3):
            return "critical3"
        elif n_bags < self.CRITICAL2:
            return "critical2"
        elif n_bags < self.CRITICAL1:
            return "critical1"
        else:
            return "ok"

    def action_critical1(self, blood_type):
        print(f"Blood of type '{blood_type}' is less than {self.CRITICAL1} bags, emails are sent to the donors who have this type of blood")

    def action_critical2(self, blood_type):
        print(f"Blood of type '{blood_type}' is less than {self.CRITICAL2} bags, emails are sent to the government employees who have this type of blood")

    def action_critical3(self, blood_type):
        print(f"Blood of type '{blood_type}' is less than {self.CRITICAL3} bags, emails are sent to the Red Cross to request emergence blood depositing")
