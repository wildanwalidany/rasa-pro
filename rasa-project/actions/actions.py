"""
Custom Actions for RASA Nutrition Chatbot

NOTE: This chatbot does NOT use custom actions.
All nutrition responses are handled by the external NLU service
which reads from dataset_gizi.csv and returns intent + response.

This file is kept only for RASA structure compatibility.
"""

from typing import Any, Text, Dict, List
from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher

# No custom actions needed for nutrition chatbot
# All responses come from external NLU service (nutrition_nlu_interpreter.py)
