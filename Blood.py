from abc import ABC
from enum import Enum
from Donor import Donor
import time

class Blood(ABC):
    def __init__(self, donor: Donor):
        self._donor = donor
        self._add_time = int(time.time())
        self._use_by_time = 99999999999
        self._state = BloodState.IN_INVENTORY
        self._test_state = BloodTestState.NOT_TESTED
        self._feedback = ""
        self._type = ""

    @property
    def donor(self):
        return self._donor

    @property
    def add_time(self):
        return self._add_time

    @property
    def test_state(self):
        return self._test_state

    @test_state.setter
    def test_state(self, test_state):
        if isinstance(test_state, int):
            self._test_state = BloodTestState(test_state)
        elif isinstance(test_state, BloodTestState):
            self._test_state = test_state
        else:
            raise TypeError(f"unexpected type of test_state: {type(test_state)}")

    @property
    def feedback(self):
        return self._feedback

    @feedback.setter
    def feedback(self, feedback):
        self._feedback = feedback
    
    @property
    def type(self):
        return self._type

    @type.setter
    def type(self, type):
        self._type = type

    @property
    def state(self):
        return self._state

    @property
    def use_by(self):
        return self._use_by_time

    @use_by.setter
    def use_by(self, new_use_by):
        self._use_by_time = new_use_by

    @state.setter
    def state(self, state):
        if isinstance(state, int):
            self._state = BloodState(state)
        elif isinstance(state, BloodState):
            self._state = state
        else:
            raise TypeError(f"unexpected type of state: {type(state)}")

    def is_expired(self):
        return int(time.time()) >= self._use_by_time

    def is_good_blood(self):
        #print(f"my state is {self._test_state}, good is {BloodTestState.GOOD}, equals? {BloodTestState.GOOD == self._test_state}")
        return self._test_state == BloodTestState.GOOD

    def serialize(self):
        pass



class BloodTestState(Enum):
    NOT_TESTED = 1
    GOOD = 2
    BAD = 3


class BloodState(Enum):
    IN_INVENTORY = 1
    TESTING = 2
    USED = 3
    DISPOSED = 4


