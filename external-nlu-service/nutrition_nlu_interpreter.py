"""
External NLU Interpreter Service for Nutrition Chatbot
Flask API that provides NLU parsing using trained Indonesian BERT model
Compatible with RASA's NLUCommandAdapter
"""

from flask import Flask, request, jsonify
from transformers import BertTokenizer, BertForSequenceClassification
import torch
import pickle
import pandas as pd
import os

app = Flask(__name__)

# Configuration
MODEL_PATH = "../nutrition_nlu_model"
PORT = 3000
HOST = "0.0.0.0"

print("="*80)
print("External NLU Interpreter Service - Nutrition Chatbot")
print("="*80)

# Load nutrition dataset for responses
csv_path = "../dataset_gizi.csv"
nutrition_data = None
try:
    nutrition_data = pd.read_csv(csv_path)
    print(f"\nNutrition dataset loaded: {len(nutrition_data)} entries")
except Exception as e:
    print(f"\nWarning: Could not load nutrition dataset: {e}")

# Load model, tokenizer, and label encoder
def load_nlu_model(model_path=MODEL_PATH):
    """Load trained BERT model, tokenizer, and label encoder."""
    print(f"\nLoading model from: {model_path}")
    
    if not os.path.exists(model_path):
        print(f"ERROR: Model path '{model_path}' does not exist!")
        print("Please run 'python train_nutrition_nlu_model.py' first to train the model.")
        return None, None, None
    
    try:
        # Increase timeout for slow connections
        os.environ['HF_HUB_DOWNLOAD_TIMEOUT'] = '300'
        
        # Load tokenizer and model with local_files_only to avoid downloading
        tokenizer = BertTokenizer.from_pretrained(model_path, local_files_only=True)
        model = BertForSequenceClassification.from_pretrained(model_path, local_files_only=True)
        model.eval()
        
        # Load label encoder
        with open(f"{model_path}/label_encoder.pkl", "rb") as f:
            label_encoder = pickle.load(f)
        
        print("Model loaded successfully!")
        print(f"Number of classes: {len(label_encoder.classes_)}")
        print(f"Classes: {list(label_encoder.classes_)}")
        
        return model, tokenizer, label_encoder
        
    except Exception as e:
        print(f"ERROR loading model: {e}")
        return None, None, None

# Load the model
model, tokenizer, label_encoder = load_nlu_model()

def predict_intent(text, model, tokenizer, label_encoder):
    """Predict intent using BERT model."""
    
    # Handle special cases
    if text == '/session_start' or text.strip() == '':
        return {
            "name": "session_start",
            "confidence": 1.0
        }
    
    # Tokenize and predict
    inputs = tokenizer(
        text, 
        return_tensors="pt", 
        truncation=True, 
        padding=True,
        max_length=128
    )
    
    with torch.no_grad():
        outputs = model(**inputs)
        probs = torch.nn.functional.softmax(outputs.logits, dim=-1)
        pred_idx = torch.argmax(probs, dim=1).item()
        intent_name = label_encoder.inverse_transform([pred_idx])[0]
        confidence = probs[0][pred_idx].item()
    
    return {
        "name": intent_name,
        "confidence": confidence
    }

def get_response_from_dataset(text, intent_name):
    """Get response from nutrition dataset based on user input and intent."""
    if nutrition_data is None:
        return None
    
    try:
        # Try exact match first
        exact_match = nutrition_data[nutrition_data['User Input'].str.lower() == text.lower()]
        if not exact_match.empty:
            return exact_match.iloc[0]['Response']
        
        # Get any response for this intent
        intent_responses = nutrition_data[nutrition_data['Intent'] == intent_name]
        if not intent_responses.empty:
            # Return first response for this intent
            return intent_responses.iloc[0]['Response']
    except Exception as e:
        print(f"Error getting response: {e}")
    
    return None

def parse_message(text):
    """
    Parse user message and return RASA-compatible response.
    Returns: {"text": "...", "intent": {...}, "entities": [...]}
    """
    if model is None:
        return {
            "text": text,
            "intent": {"name": "nlu_fallback", "confidence": 0.0},
            "entities": []
        }
    
    # Predict intent
    intent = predict_intent(text, model, tokenizer, label_encoder)
    
    # Get response from dataset
    response_text = get_response_from_dataset(text, intent["name"])
    
    # Build response
    result = {
        "text": text,
        "intent": intent,
        "entities": [],
        "intent_ranking": [intent]
    }
    
    # Add custom field for response (RASA actions can use this)
    if response_text:
        result["response_text"] = response_text
    
    return result

# ============================================================
# Flask Routes
# ============================================================

@app.route("/", methods=["GET"])
def home():
    """Health check endpoint."""
    return jsonify({
        "service": "External NLU Interpreter - Nutrition Chatbot",
        "status": "running",
        "language": "Indonesian",
        "model_loaded": model is not None,
        "endpoints": {
            "parse": "/model/parse (POST)",
            "interpret": "/interpret (POST)",
            "health": "/ (GET)"
        }
    })

@app.route("/model/parse", methods=["POST"])
@app.route("/interpret", methods=["POST"])
def parse():
    """
    Main NLU parsing endpoint compatible with RASA NLUCommandAdapter.
    Expects JSON: {"text": "user message"}
    Returns: {"text": "...", "intent": {...}, "entities": [...]}
    """
    try:
        data = request.get_json()
        
        if not data or "text" not in data:
            return jsonify({
                "error": "Missing 'text' field in request body"
            }), 400
        
        user_input = data.get("text", "")
        
        print(f"\n[NLU] Received: {user_input}")
        
        # Parse the message
        response = parse_message(user_input)
        
        print(f"[NLU] Intent: {response.get('intent', {}).get('name')} "
              f"(confidence: {response.get('intent', {}).get('confidence', 0):.2f})")
        
        if "response_text" in response:
            print(f"[NLU] Response: {response['response_text'][:50]}...")
        
        return jsonify(response)
    
    except Exception as e:
        print(f"[ERROR] {str(e)}")
        return jsonify({
            "error": str(e),
            "text": data.get("text", "") if data else ""
        }), 500

@app.route("/health", methods=["GET"])
def health():
    """Health check endpoint."""
    return jsonify({
        "status": "healthy",
        "model_loaded": model is not None
    })

if __name__ == "__main__":
    if model is None:
        print("\n" + "="*80)
        print("WARNING: Model not loaded!")
        print("Please run 'python train_nutrition_nlu_model.py' first to train the model.")
        print("="*80 + "\n")
    else:
        print(f"\n{'='*80}")
        print(f"Starting Nutrition NLU Service on http://{HOST}:{PORT}")
        print(f"Endpoint: http://{HOST}:{PORT}/model/parse")
        print(f"{'='*80}\n")
    
    app.run(host=HOST, port=PORT, debug=False)
