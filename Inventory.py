from Donor import *
from Blood import *
from Request import *
from Organization import *
from LevelChecker import *
from BloodFilter import *
import os
from time import sleep
from threading import Thread, get_ident




class Inventory(object):
    def __init__(self):
        self._bloods = []
        self._requests = []
        self._lc = LevelChecker(self)
        self._th = Thread(target=self.check_blood_per_min)
        self._th.setDaemon(True)

    @property
    def bloods(self):
        return self._bloods

    def start_checking(self):
        self._th.start()

    def check_blood_per_min(this):
        os.environ['CHECKING_THREAD'] = str(get_ident())
        while True:
            # print(os.environ)
            # w = os.environ.get("WERKZEUG_RUN_MAIN")
            # print(f"WERKZEUG_RUN_MAIN: {w}")
            # prev_id = os.environ.get("CHECKING_THREAD", None)
            # print(f"pid: {os.getpid()}, tid: {get_ident()}, prev_tid: {prev_id}")
            # if prev_id is not None:
            #     if int(prev_id) != get_ident():
            #         return
            this._lc.check_level()
            print("checking...")
            sleep(6.00000)

    def add_blood(self, donor_name: str, donor_id: str, source: str, blood_type="", use_by=-1) -> int:
        donor = Donor(donor_name, donor_id)
        blood = Blood(len(self._bloods), donor)
        # print("add blood...")
        if source == 'Bat-Mobile':
            blood.test_state = BloodTestState.NOT_TESTED
        elif source == 'Red Cross':
            blood.test_state = BloodTestState.GOOD
            blood.use_by = use_by
            blood.type = blood_type
        else:
            raise ValueError(f"invalid source: {source}")
        self._bloods.append(blood)
        return len(self._bloods) - 1
        

    def request_blood(self, n_bags: int, blood_type: str, org: Organization) -> list:
        bloods = filter_blood_to_send(self._bloods, int(time.time()))
        bloods = filter_blood_by_type(bloods, blood_type)
        if n_bags > len(bloods) or n_bags <= 0:
            return None
        bloods_to_send = bloods[0:n_bags]
        self.mark_bloods(bloods_to_send, BloodState.USED)
        print(f"marking blood: {bloods_to_send}")
        size = len(self._requests)
        self._requests.append(Request(size, org, bloods_to_send))
        return bloods_to_send

    def mark_bloods(self, bloods: list, state: BloodState):
        for blood in bloods:
            blood.state = state

    def get_blood_public_info(self) -> dict:
        raise DeprecationWarning('this is deprecated')
        bloods = filter_blood_to_send(self._bloods)
        blood_types = {}
        for blood in bloods:
            type = blood.type
            if blood_types.get(type, None) is None:
                blood_types[type] = 1
            else:
                blood_types[type] += 1
        return blood_types

    def get_blood_level_by(self, cat: str, bloods: list=None) -> dict:
        if bloods is None:
            bloods = self._bloods
        if cat == "type":
            blood_types = {}
            for blood in bloods:
                type = blood.type
                if blood_types.get(type, None) is None:
                    blood_types[type] = 1
                else:
                    blood_types[type] += 1
            return blood_types
        else:
            raise NotImplementedError()

    def get_blood_by_id(self, id: int) -> Blood:
        return self._bloods[id]

    def update_blood(self, id: int, new_blood: Blood):
        self._bloods[id] = new_blood
        new_blood.id = id

    def get_request_by_id(self, id: int) -> Request:
        return self._requests[id]

    def get_request_list(self) -> list:
        return self._requests


    # see blood_inventory.html to check what are inside opt
    def get_bloods_by_conditions(self, opt: dict) -> list:
        bloods = list(self._bloods)
        print(f"id1: {id(bloods)}, id2: {id(self._bloods)}")
        # bf = BloodFilter()
        res = opt.get('id', None)
        if res is not None:
            bloods = filter_blood_by_id(bloods, int(res))
        res = opt.get('type')
        if res is not None:
            bloods = filter_blood_by_type(bloods, res)
        res = opt.get('isexpired', None)
        if res is not None:
            bloods = filter_expired_blood(bloods, int(time.time()))
        res = opt.get('state', None)
        if res is not None:
            bloods = filter_blood_by_state(bloods, int(res))
        res = opt.get('test_state', None)
        if res is not None:
            bloods = filter_blood_by_test_state(bloods, int(res))

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
        


        

