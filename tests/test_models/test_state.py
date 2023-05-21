#!/usr/bin/python3
"""
Defines the unittests for models/test_state.py
"""
import os
from tests.test_models.test_base_model import TestBasemodel
from models.state import State


class TestState(TestBasemodel):
    """Unittests for testing the State class."""

    def __init__(self, *args, **kwargs):
        """Testing initialization of State"""
        super().__init__(*args, **kwargs)
        self.name = "State"
        self.value = State

    def test_name_attr(self):
        """Testing State name attribute."""
        new = self.value()
        self.assertTrue("name" in new.__dir__())
