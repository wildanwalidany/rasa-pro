# 🚀 Complete Setup Guide - RASA Nutrition Chatbot with Database Integration

## 📁 Project Structure

```
new-tugas2/
├── database/                           # NEW - Database integration
│   ├── create_nutrition_db.sql        # SQL script to create database
│   ├── import_data.py                 # Import CSV to database
│   ├── api_service.py                 # REST API service
│   ├── test_connection.py             # Database connection test
│   ├── test_queries.sql               # SQL test commands
│   ├── requirements.txt               # Python dependencies
│   └── README.md                      # Database documentation
├── external-nlu-service/              # External NLU service
│   ├── nutrition_nlu_interpreter.py   # NLU interpreter
│   └── train_nutrition_nlu_model.py   # Model training
├── rasa-project/                      # RASA chatbot
│   ├── actions/
│   │   └── actions.py                 # UPDATED - Database integration
│   ├── data/
│   │   ├── nlu.yml
│   │   ├── stories.yml
│   │   └── rules.yml
│   ├── config.yml
│   ├── domain.yml
│   └── endpoints.yml
├── dataset_gizi.csv                   # Source data
└── README.md                          # Main documentation
```

## 🔧 Installation Steps

### Step 1: Install MySQL/XAMPP

1. Download and install XAMPP: https://www.apachefriends.org/
2. Start Apache and MySQL from XAMPP Control Panel
3. Open phpMyAdmin: http://localhost/phpmyadmin

### Step 2: Create Database

1. In phpMyAdmin, click "SQL" tab
2. Copy entire content from `database/create_nutrition_db.sql`
3. Paste and click "Go"
4. Verify "nutrition_db" appears in left sidebar

### Step 3: Install Python Dependencies

```bash
# Install database dependencies
cd database
pip install -r requirements.txt

# Install RASA dependencies
cd ../rasa-project
pip install -r requirements.txt
```

### Step 4: Import CSV Data to Database

```bash
cd database
python import_data.py
```

Expected output:
- ✓ Successfully connected to MySQL database
- ✓ Import completed successfully!
- Total imported: 700+ records

### Step 5: Test Database Connection

```bash
cd database
python test_connection.py
```

Expected output:
- ✓ Connected successfully!
- ✓ Total intents: 13
- ✓ Total nutrition records: 700+
- ✓ Total products: 17

## 🧪 Testing with phpMyAdmin

### Quick Test Queries

Copy these into phpMyAdmin SQL tab:

```sql
-- 1. Check database exists
USE nutrition_db;

-- 2. View all intents
SELECT * FROM intents;

-- 3. Count nutrition data
SELECT COUNT(*) FROM nutrition_data;

-- 4. View sample products
SELECT product_name, calories, protein, fat 
FROM products 
LIMIT 10;

-- 5. Search for "kalori" questions
SELECT user_input, response 
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%kalori%'
LIMIT 5;

-- 6. Get Teh Botol nutrition info
SELECT * FROM products 
WHERE product_name LIKE '%Teh Botol%';

-- 7. Test stored procedure
CALL search_nutrition_data('diet sehat');

-- 8. Get statistics
SELECT * FROM intent_statistics;
```

### Expected Results

| Query | Expected Result |
|-------|----------------|
| Total intents | 13 |
| Total nutrition data | 700+ |
| Total products | 17 |
| Teh Botol calories | 140 kkal |
| Indomie sodium | 730 mg |

## 🌐 Starting the Services

### Service 1: Database API (Port 8000)

```bash
cd database
python api_service.py
```

Test API:
- Swagger UI: http://localhost:8000/docs
- Health: http://localhost:8000/health
- Search: http://localhost:8000/api/search?q=kalori

### Service 2: External NLU Service (Port 3000)

```bash
cd external-nlu-service
python nutrition_nlu_interpreter.py
```

Test NLU:
```bash
curl -X POST http://localhost:3000 -H "Content-Type: application/json" -d "{\"text\":\"Halo\"}"
```

### Service 3: RASA Action Server (Port 5055)

```bash
cd rasa-project
rasa run actions
```

### Service 4: RASA Server (Port 5005)

```bash
cd rasa-project
rasa run --enable-api --cors "*"
```

## 💬 Testing the Complete System

### Option 1: RASA Shell

```bash
cd rasa-project
rasa shell
```

Example conversation:
```
You: Halo
Bot: Halo! Ada yang bisa saya bantu terkait informasi gizi?

You: Berapa kalori Teh Botol?
Bot: Teh Botol Sosro 350 ml mengandung ±140 kkal.

You: Apa rekomendasi sarapan sehat?
Bot: Oatmeal dengan buah segar sangat bagus.

You: Terima kasih
Bot: Sama-sama! Jangan lupa pola makan seimbang.
```

### Option 2: API Testing

```bash
# Using curl
curl -X POST http://localhost:5005/webhooks/rest/webhook \
  -H "Content-Type: application/json" \
  -d '{"sender":"test_user","message":"Halo"}'

# Using Python
import requests
response = requests.post(
    "http://localhost:5005/webhooks/rest/webhook",
    json={"sender": "test_user", "message": "Berapa kalori Teh Botol?"}
)
print(response.json())
```

## 🔍 Verification Checklist

- [ ] MySQL/XAMPP running
- [ ] Database `nutrition_db` created
- [ ] 13 intents in database
- [ ] 700+ nutrition data records
- [ ] 17 products in database
- [ ] Database API running on port 8000
- [ ] External NLU running on port 3000
- [ ] RASA action server running on port 5055
- [ ] RASA server running on port 5005
- [ ] Can chat via `rasa shell`

## 📊 Database API Endpoints

### GET Endpoints

```bash
# Health check
GET http://localhost:8000/health

# Search nutrition data
GET http://localhost:8000/api/search?q=kalori&limit=5

# Get product info
GET http://localhost:8000/api/product?name=Teh%20Botol

# Get all intents
GET http://localhost:8000/api/intents

# Get statistics
GET http://localhost:8000/api/statistics

# Get recent conversations
GET http://localhost:8000/api/conversations?limit=10

# Get all products
GET http://localhost:8000/api/products?limit=20
```

### POST Endpoints

```bash
# Log conversation
POST http://localhost:8000/api/log
Content-Type: application/json
{
  "session_id": "user123",
  "user_input": "Halo",
  "detected_intent": "greeting",
  "confidence": 0.95,
  "bot_response": "Halo! Ada yang bisa saya bantu?",
  "response_time": 120
}
```

## 🛠️ Troubleshooting

### Database Connection Error

```bash
# Check MySQL is running
netstat -ano | findstr :3306

# Test connection
cd database
python test_connection.py
```

### Import Data Fails

```python
# Check CSV file exists
import os
print(os.path.exists('dataset_gizi.csv'))

# Check MySQL credentials in import_data.py
DB_CONFIG = {
    'user': 'root',      # Change if different
    'password': '',      # Add your password
}
```

### API Service Not Starting

```bash
# Check port 8000 availability
netstat -ano | findstr :8000

# Use different port
uvicorn api_service:app --port 8001
```

### RASA Can't Connect to Database

1. Check `rasa-project/actions/actions.py`
2. Verify DB_CONFIG settings:
```python
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',
    'password': '',  # Update if needed
    'database': 'nutrition_db'
}
```

## 📈 Advanced Features

### 1. View Real-time Logs

```sql
-- In phpMyAdmin, run this query periodically
SELECT * FROM conversation_logs 
ORDER BY created_at DESC 
LIMIT 20;
```

### 2. Analyze User Patterns

```sql
-- Most popular intents
SELECT 
    detected_intent,
    COUNT(*) as total
FROM conversation_logs
GROUP BY detected_intent
ORDER BY total DESC;

-- Average confidence by intent
SELECT 
    detected_intent,
    AVG(confidence_score) as avg_confidence
FROM conversation_logs
GROUP BY detected_intent;
```

### 3. Export Data

```sql
-- Export product data
SELECT * FROM products
INTO OUTFILE 'C:/xampp/tmp/products_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```

## 🎯 Quick Start Commands

```bash
# Start all services in separate terminals

# Terminal 1: Database API
cd database && python api_service.py

# Terminal 2: External NLU
cd external-nlu-service && python nutrition_nlu_interpreter.py

# Terminal 3: RASA Actions
cd rasa-project && rasa run actions

# Terminal 4: RASA Server
cd rasa-project && rasa run --enable-api

# Terminal 5: Test chatbot
cd rasa-project && rasa shell
```

## 📚 Documentation Links

- Database README: `database/README.md`
- Test Queries: `database/test_queries.sql`
- API Documentation: http://localhost:8000/docs
- RASA Documentation: https://rasa.com/docs/

## ✅ Success Criteria

Your system is working correctly if:

1. ✓ All 4 services are running without errors
2. ✓ Database contains 13 intents and 700+ records
3. ✓ API health check returns `{"status": "healthy"}`
4. ✓ NLU service responds to test queries
5. ✓ RASA shell conversation works smoothly
6. ✓ Conversations are logged to database

## 🎉 You're All Set!

Your RASA Nutrition Chatbot with Database Integration is ready!

For questions or issues, check:
- `database/README.md` for database help
- `database/test_queries.sql` for SQL examples
- http://localhost:8000/docs for API reference

---

**Happy Coding!** 🚀
