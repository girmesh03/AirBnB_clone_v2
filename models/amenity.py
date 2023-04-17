#!/usr/bin/python3
"""
A module for defining Amenity class that inherits
from BaseModel and stores data in a SQL database.
"""

from models.base_model import BaseModel, Base
from models import storage_type
from sqlalchemy import Column, String


class Amenity(BaseModel, Base):
    """
    A class for representing amenities in the HBNB project.

    Attributes:
    -----------
    name : str
        The name of the amenity.
    """
    __tablename__ = 'amenities'

    name = Column(String(128), nullable=False) if storage_type == 'db' else ''
