import requests
import logging
from typing import Any, Dict, List, Text, Optional

from rasa.engine.recipes.default_recipe import DefaultV1Recipe
from rasa.engine.graph import ExecutionContext, GraphComponent
from rasa.engine.storage.resource import Resource
from rasa.engine.storage.storage import ModelStorage
from rasa.shared.nlu.training_data.message import Message
from rasa.shared.nlu.constants import TEXT, INTENT, ENTITIES

logger = logging.getLogger(__name__)

@DefaultV1Recipe.register(
    DefaultV1Recipe.ComponentType.INTENT_CLASSIFIER, is_trainable=False
)
@DefaultV1Recipe.register(
    DefaultV1Recipe.ComponentType.ENTITY_EXTRACTOR, is_trainable=False
)
class NLUCommandAdapter(GraphComponent):
    """Custom NLU component that connects to external BERT NLU service."""

    @staticmethod
    def required_components() -> List[type]:
        """Components that should be included in the pipeline before this component."""
        return []

    @classmethod
    def create(
        cls,
        config: Dict[Text, Any],
        model_storage: ModelStorage,
        resource: Resource,
        execution_context: ExecutionContext,
    ) -> "NLUCommandAdapter":
        """Creates a new component (see parent class for full docstring)."""
        return cls(config)

    def __init__(self, config: Dict[Text, Any]) -> None:
        """Initialize the component."""
        self.component_config = config
        self.nlu_service_url = config.get("nlu_service_url", "http://localhost:3000/interpret")

    def process(self, messages: List[Message]) -> List[Message]:
        """Process incoming messages and predict intent and entities using external NLU."""
        for message in messages:
            self._set_intent_and_entities(message)
        return messages

    def _set_intent_and_entities(self, message: Message) -> None:
        """Call external NLU service and set intent and entities."""
        text = message.get(TEXT)
        
        if not text:
            return

        try:
            # Call external NLU service
            logger.info(f"Calling external NLU service for text: {text}")
            response = requests.post(
                self.nlu_service_url,
                json={"text": text},
                timeout=5
            )
            
            if response.status_code == 200:
                result = response.json()
                
                # Set intent
                intent_data = result.get("intent", {})
                message.set(
                    INTENT,
                    {
                        "name": intent_data.get("name"),
                        "confidence": intent_data.get("confidence")
                    },
                    add_to_output=True
                )
                
                # Set entities
                entities = result.get("entities", [])
                message.set(ENTITIES, entities, add_to_output=True)
                
                logger.info(f"Intent: {intent_data.get('name')}, Confidence: {intent_data.get('confidence')}")
                logger.info(f"Entities: {entities}")
            else:
                logger.error(f"External NLU service returned status code: {response.status_code}")
                
        except requests.exceptions.RequestException as e:
            logger.error(f"Error calling external NLU service: {e}")
            # Set default fallback intent
            message.set(
                INTENT,
                {"name": "nlu_fallback", "confidence": 0.0},
                add_to_output=True
            )

    @classmethod
    def load(
        cls,
        config: Dict[Text, Any],
        model_storage: ModelStorage,
        resource: Resource,
        execution_context: ExecutionContext,
        **kwargs: Any,
    ) -> "NLUCommandAdapter":
        """Loads trained component (see parent class for full docstring)."""
        return cls(config)