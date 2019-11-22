
class Donor(object):
    def __init__(self, name: str, id: str):
        self._name = name
        self._id = id
        self._history = []
        
    @property
    def name(self):
        return self._name

    @property
    def id(self):
        return self._id
    
    @property
    def history(self):
        return self._history
