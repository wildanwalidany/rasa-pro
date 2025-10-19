"""
Training NLU Model for Nutrition Chatbot (Indonesian)
Uses dataset_gizi.csv to train BERT model for 13 nutrition-related intents
"""

import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder
from transformers import BertTokenizer, BertForSequenceClassification, AdamW
import torch
from torch.utils.data import Dataset, DataLoader
import matplotlib.pyplot as plt
import os

print("="*80)
print("Training External NLU Model for Nutrition Chatbot (Indonesian)")
print("="*80)

# Load dataset
csv_path = "../dataset_gizi.csv"
df = pd.read_csv(csv_path)

print(f"\nDataset loaded: {len(df)} samples")
print(f"Unique intents: {df['Intent'].nunique()}")
print(f"\nIntent distribution:")
print(df['Intent'].value_counts())

# Prepare data
texts = df['User Input'].values
labels = df['Intent'].values

# Encode labels
label_encoder = LabelEncoder()
encoded_labels = label_encoder.fit_transform(labels)

print(f"\nNumber of classes: {len(label_encoder.classes_)}")
print(f"Classes: {label_encoder.classes_}")

# Split data
X_train, X_test, y_train, y_test = train_test_split(
    texts, encoded_labels, test_size=0.2, random_state=42, stratify=encoded_labels
)

print(f"\nTraining samples: {len(X_train)}")
print(f"Testing samples: {len(X_test)}")

# Load Indonesian BERT tokenizer
# Using smaller indolem model or fallback to base uncased (faster download)
MODEL_NAME = "bert-base-uncased"  # Smaller, faster, works well for Indonesian too
print(f"\nUsing model: {MODEL_NAME}")
print("Note: Using bert-base-uncased for faster download. Works well for Indonesian.")

# Increase timeout for slow connections
import os
os.environ['HF_HUB_DOWNLOAD_TIMEOUT'] = '300'  # 5 minutes timeout

tokenizer = BertTokenizer.from_pretrained(MODEL_NAME)

# Create dataset class
class NutritionDataset(Dataset):
    def __init__(self, texts, labels, tokenizer, max_length=128):
        self.texts = texts
        self.labels = labels
        self.tokenizer = tokenizer
        self.max_length = max_length
    
    def __len__(self):
        return len(self.texts)
    
    def __getitem__(self, idx):
        text = str(self.texts[idx])
        label = self.labels[idx]
        
        encoding = self.tokenizer(
            text,
            add_special_tokens=True,
            max_length=self.max_length,
            padding='max_length',
            truncation=True,
            return_tensors='pt'
        )
        
        return {
            'input_ids': encoding['input_ids'].flatten(),
            'attention_mask': encoding['attention_mask'].flatten(),
            'labels': torch.tensor(label, dtype=torch.long)
        }

print("\nPreparing datasets...")

# Create datasets
train_dataset = NutritionDataset(X_train, y_train, tokenizer)
test_dataset = NutritionDataset(X_test, y_test, tokenizer)

# Create dataloaders
BATCH_SIZE = 16
train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=BATCH_SIZE)

# Load model
print(f"\nLoading BERT model: {MODEL_NAME}")
model = BertForSequenceClassification.from_pretrained(
    MODEL_NAME,
    num_labels=len(label_encoder.classes_)
)

# Setup device
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
model.to(device)
print(f"Using device: {device}")

# Training setup
EPOCHS = 10  # Reduced from 15 for faster training
LEARNING_RATE = 2e-5

optimizer = AdamW(model.parameters(), lr=LEARNING_RATE)

# Training function
def train_epoch(model, data_loader, optimizer, device):
    model.train()
    total_loss = 0
    correct = 0
    total = 0
    
    for batch in data_loader:
        input_ids = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        labels = batch['labels'].to(device)
        
        optimizer.zero_grad()
        
        outputs = model(
            input_ids=input_ids,
            attention_mask=attention_mask,
            labels=labels
        )
        
        loss = outputs.loss
        logits = outputs.logits
        
        loss.backward()
        optimizer.step()
        
        total_loss += loss.item()
        
        preds = torch.argmax(logits, dim=1)
        correct += (preds == labels).sum().item()
        total += labels.size(0)
    
    avg_loss = total_loss / len(data_loader)
    accuracy = correct / total
    
    return avg_loss, accuracy

# Evaluation function
def eval_model(model, data_loader, device):
    model.eval()
    correct = 0
    total = 0
    
    with torch.no_grad():
        for batch in data_loader:
            input_ids = batch['input_ids'].to(device)
            attention_mask = batch['attention_mask'].to(device)
            labels = batch['labels'].to(device)
            
            outputs = model(
                input_ids=input_ids,
                attention_mask=attention_mask
            )
            
            logits = outputs.logits
            preds = torch.argmax(logits, dim=1)
            
            correct += (preds == labels).sum().item()
            total += labels.size(0)
    
    accuracy = correct / total
    return accuracy

# Training loop
print("\n" + "="*80)
print("Starting Training...")
print("="*80)

train_losses = []
train_accuracies = []

for epoch in range(EPOCHS):
    loss, acc = train_epoch(model, train_loader, optimizer, device)
    train_losses.append(loss)
    train_accuracies.append(acc)
    
    print(f"Epoch {epoch+1}/{EPOCHS} | Loss: {loss:.4f} | Accuracy: {acc:.4f}")

# Save model
MODEL_PATH = "nutrition_nlu_model"
os.makedirs(MODEL_PATH, exist_ok=True)

model.save_pretrained(MODEL_PATH)
tokenizer.save_pretrained(MODEL_PATH)

# Save label encoder
import pickle
with open(f"{MODEL_PATH}/label_encoder.pkl", "wb") as f:
    pickle.dump(label_encoder, f)

print(f"\nModel saved to: {MODEL_PATH}/")

# Evaluate
print("\n" + "="*80)
print("Evaluating Model...")
print("="*80)

test_accuracy = eval_model(model, test_loader, device)
print(f"\nTest Accuracy: {test_accuracy:.4f}")

# Detailed evaluation
from sklearn.metrics import classification_report

model.eval()
all_preds = []
all_labels = []

with torch.no_grad():
    for batch in test_loader:
        input_ids = batch['input_ids'].to(device)
        attention_mask = batch['attention_mask'].to(device)
        labels = batch['labels']
        
        outputs = model(input_ids=input_ids, attention_mask=attention_mask)
        preds = torch.argmax(outputs.logits, dim=1).cpu().numpy()
        
        all_preds.extend(preds)
        all_labels.extend(labels.numpy())

print("\nClassification Report:")
print(classification_report(
    all_labels, 
    all_preds, 
    target_names=label_encoder.classes_,
    zero_division=0
))

# Plot training metrics
plt.figure(figsize=(12, 4))

plt.subplot(1, 2, 1)
plt.plot(train_losses)
plt.title('Training Loss')
plt.xlabel('Epoch')
plt.ylabel('Loss')
plt.grid(True)

plt.subplot(1, 2, 2)
plt.plot(train_accuracies)
plt.title('Training Accuracy')
plt.xlabel('Epoch')
plt.ylabel('Accuracy')
plt.grid(True)

plt.tight_layout()
plt.savefig(f"{MODEL_PATH}/training_metrics.png")
print(f"\nTraining metrics plot saved to: {MODEL_PATH}/training_metrics.png")

print("\n" + "="*80)
print("Training Complete!")
print("="*80)
