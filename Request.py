from Organization import *
import time

class Request(object):
    def __init__(self, id: int, org: Organization, bloods: list):
        self._org = org
        self._bloods: list = bloods
        self._time = int(time.time())
        self._id = id


    @property
    def bloods(self) -> list:
        return self._bloods

    @property
    def org(self) -> Organization:
        return self._org

    @property
    def time(self) -> int:
        return self._time

    @property
    def id(self) -> int:
        return self._id

    @property
    def n_bags(self) -> int:
        return len(self._bloods)


    