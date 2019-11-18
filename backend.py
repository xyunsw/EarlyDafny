from BackendApi import *
import uuid
import sys

api = BackendApi()
print("Initializing backend...", file=sys.stderr)
# api.add_blood({"donor_name": "Sofi", "donor_id": "fsbyfgjgjse"})
# api.add_blood({"donor_name": "Miku", "donor_id": "393939393939"})
# api.add_blood({"donor_name": "f*** system", "donor_id": "fhuish uishzzd"})
# api.add_blood({"donor_name": "anonymous🙃", "donor_id": "hurigehge"})
# api.add_blood({"donor_name": "😡🙃", "donor_id": "fueigfudhu"})

# api.update_blood({"id": 0, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
# api.update_blood({"id": 1, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
# api.update_blood({"id": 2, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
# api.update_blood({"id": 3, "use_by": "16666776", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
# api.update_blood({"id": 4, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "B"})

for i in range(210):
    res = api.add_blood({"donor_name": "Miku", "donor_id": str(uuid.uuid1()), "source": "Bat-Mobile"})
    api.update_blood({"id": res['id'], "use_by": 1578040193 + i, "state": 1, "test_state": 2, "feedback": "", "type": "A"})

