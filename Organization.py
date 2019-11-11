from abc import ABC


class Organization(ABC):
    def __init__(self, name, address, phone):
        self._name: str = name
        self._address: str = address
        self._phone: str = phone

    @property
    def name(self) -> str:
        return self._name

    @property
    def address(self) -> str:
        return self._address

    @property
    def phone(self) -> str:
        return self._phone

