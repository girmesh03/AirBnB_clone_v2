#!/usr/bin/python3
"""
City Module for HBNB project
Defines the City class that inherits from BaseModel
"""

from models.base_model import BaseModel


class City(BaseModel):
    """
    Represents a city.

    Attributes:
        state_id (str): the ID of the state where the city is located
        name (str): the name of the city
    """

    def __init__(self, *args, **kwargs):
        """
        Instantiates a new City object.

        Args:
            args: Variable length argument list.
            kwargs: Arbitrary keyword arguments.
        """
        super().__init__(*args, **kwargs)
        self.state_id = kwargs.get("state_id", "")
        self.name = kwargs.get("name", "")
