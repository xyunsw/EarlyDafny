from BackendApi import *
import sys

api = BackendApi()
print("Initializing backend...", file=sys.stderr)
api.add_blood({"donor_name": "Sofi", "donor_id": "fsbyfgjgjse"})
api.add_blood({"donor_name": "Miku", "donor_id": "393939393939"})
api.add_blood({"donor_name": "f*** system", "donor_id": "fhuish uishzzd"})

api.update_blood({"id": 0, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
api.update_blood({"id": 1, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})
api.update_blood({"id": 2, "use_by": "166666666666", "state": 1, "test_state": 2, "feedback": "fhsufhs", "type": "A"})


