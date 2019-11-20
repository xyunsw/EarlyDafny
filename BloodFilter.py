from Blood import *


# in-place sort
def sort_blood_by_useby_asc(bloods: list):
    sorted_tail: int = 0
    while sorted_tail < len(bloods):
        to_swap: int = sorted_tail
        while to_swap >= 1 and bloods[to_swap - 1].use_by > bloods[to_swap].use_by:
            bloods[to_swap - 1], bloods[to_swap] = bloods[to_swap], bloods[to_swap - 1]
            to_swap -= 1
        sorted_tail += 1

def sort_blood_by_useby_desc(bloods: list):
    sorted_tail: int = 0
    while sorted_tail < len(bloods):
        to_swap: int = sorted_tail
        while to_swap >= 1 and bloods[to_swap - 1].use_by < bloods[to_swap].use_by:
            bloods[to_swap - 1], bloods[to_swap] = bloods[to_swap], bloods[to_swap - 1]
            to_swap -= 1
        sorted_tail += 1

def sort_blood_by_addtime_asc(bloods: list):
    sorted_tail: int = 0
    while sorted_tail < len(bloods):
        to_swap: int = sorted_tail
        while to_swap >= 1 and bloods[to_swap - 1].add_time > bloods[to_swap].add_time:
            bloods[to_swap - 1], bloods[to_swap] = bloods[to_swap], bloods[to_swap - 1]
            to_swap -= 1
        sorted_tail += 1

def sort_blood_by_addtime_desc(bloods: list):
    sorted_tail: int = 0
    while sorted_tail < len(bloods):
        to_swap: int = sorted_tail
        while to_swap >= 1 and bloods[to_swap - 1].add_time < bloods[to_swap].add_time:
            bloods[to_swap - 1], bloods[to_swap] = bloods[to_swap], bloods[to_swap - 1]
            to_swap -= 1
        sorted_tail += 1

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
