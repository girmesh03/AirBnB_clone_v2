#!/usr/bin/python3
"""This module defines a base class for all models in our hbnb clone"""

import uuid
from datetime import datetime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy import Column, String, DATETIME
from models import storage_type

Base = declarative_base()


class BaseModel(Base):
    """A base class for all hbnb models"""
    if storage_type == 'db':
        id = Column(String(60), primary_key=True, nullable=False)
        created_at = Column(DATETIME, nullable=False,
                            default=datetime.utcnow())
        updated_at = Column(DATETIME, nullable=False,
                            default=datetime.utcnow())
    else:
        id = ""
        created_at = datetime.now()
        updated_at = datetime.now()

    def __init__(self, *args, **kwargs):
        """Instantiation of base model"""
        if kwargs:
            for key, value in kwargs.items():
                if key == "created_at" or key == "updated_at":
                    value = datetime.strptime(value, "%Y-%m-%dT%H:%M:%S.%f")
                if key != "__class__":
                    setattr(self, key, value)
            if "id" not in kwargs.keys():
                self.id = str(uuid.uuid4())
            if "created_at" not in kwargs.keys():
                self.created_at = datetime.now()
            if "updated_at" not in kwargs.keys():
                self.updated_at = datetime.now()
        else:
            from models import storage
            self.id = str(uuid.uuid4())
            self.created_at = datetime.now()
            self.updated_at = datetime.now()
            storage.new(self)

    def __str__(self):
        """String representation of BaseModel"""
        return "[{}] ({}) {}".format(self.__class__.__name__,
                                     self.id, self.__dict__)

    def save(self):
        """Updates the public instance attribute updated_at with the current
        datetime"""
        self.updated_at = datetime.now()
        from models import storage
        storage.save()

    def to_dict(self):
        """Returns a dictionary containing all keys/values of __dict__ of the
        instance"""
        new_dict = self.__dict__.copy()
        new_dict["__class__"] = self.__class__.__name__
        new_dict["created_at"] = self.created_at.isoformat()
        new_dict["updated_at"] = self.updated_at.isoformat()
        if "_sa_instance_state" in new_dict.keys():
            del new_dict["_sa_instance_state"]
        return new_dict

    def delete(self):
        """Delete the current instance from the storage"""
        from models import storage
        storage.delete(self)
