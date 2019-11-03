from abc import ABC
from enum import Enum
import time

class Blood(ABC):
    def __init__(self, donor: Donor, use_by: int):
        self._donor = donor
        self._add_time = int(time.time())
        self._use_by_time = 0
        self._state = BloodState.IN_INVENTORY
        self._test_state = BloodTestState.NOT_TESTED
        self._feedback = None
        self._type = None

    @property
    def donor(self):
        return self._donor

    @property
    def add_time(self):
        return self._add_time

    @property
    def test_state(self):
        return self._test_state

    @property
    def feedback(self):
        return self.feedback
    
    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, type):
        self._type = type

    @property
    def state(self):
        return self._state

    @state.setter
    def state(self, state):
        self._state = state

    def is_expired(self):
        return int(time.time()) >= self._use_by_time

    def is_good_blood(self):
        return self._test_state == BloodTestState.GOOD

    @feedback.setter
    def feedback(self, feedback: str):
        self.feedback = feedback



class BloodTestState(Enum):
    NOT_TESTED = 1
    GOOD = 2
    BAD = 3


class BloodState(Enum):
    IN_INVENTORY = 1
    TESTING = 2
    USED = 3
    DISPOSED = 4


