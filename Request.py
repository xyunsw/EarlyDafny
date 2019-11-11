from Organization import *

class Request(object):
    def __init__(self, org: Organization, bloods: list):
        self._org = org
        self._bloods: list = bloods


    @property
    def bloods(self) -> list:
        return self._bloods

    @property
    def org(self) -> Organization:
        return self._org


    