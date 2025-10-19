# 🏗️ System Architecture Diagram

## Complete Integration Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERFACE                          │
│  (Web Browser / Mobile App / Command Line / Messaging Apps)    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         │ HTTP Request
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                    RASA FRAMEWORK                               │
│                   (Port 5005)                                   │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              NLU Pipeline                                │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │  NLUCommandAdapter                                 │  │  │
│  │  │  (Sends user message to External NLU Service)      │  │  │
│  │  └──────────────┬─────────────────────────────────────┘  │  │
│  └─────────────────┼────────────────────────────────────────┘  │
│                    │                                           │
│  ┌─────────────────▼────────────────────────────────────────┐  │
│  │         Dialogue Management                              │  │
│  │  - MemoizationPolicy                                     │  │
│  │  - TEDPolicy                                            │  │
│  │  - RulePolicy                                           │  │
│  └──────────────────┬───────────────────────────────────────┘  │
└────────────────────┼───────────────────────────────────────────┘
                     │
                     │ Triggers Actions
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              RASA ACTION SERVER                                 │
│                  (Port 5055)                                    │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Custom Actions:                                         │  │
│  │  ├─ ActionSearchNutrition                               │  │
│  │  ├─ ActionGetProductInfo                                │  │
│  │  ├─ ActionLogConversation                               │  │
│  │  └─ ActionGetStatistics                                 │  │
│  └──────────────────┬───────────────────────────────────────┘  │
└────────────────────┼───────────────────────────────────────────┘
                     │
      ┌──────────────┴──────────────┐
      │                             │
      ▼                             ▼
┌──────────────────┐    ┌────────────────────────────┐
│  EXTERNAL NLU    │    │  DATABASE API SERVICE      │
│    SERVICE       │    │      (Port 8000)          │
│  (Port 3000)     │    │      FastAPI              │
│                  │    │                            │
│  Transformer     │    │  Endpoints:                │
│  Model (BERT)    │    │  ├─ /api/search           │
│  + CSV Dataset   │    │  ├─ /api/product          │
│                  │    │  ├─ /api/intents          │
│  Returns:        │    │  ├─ /api/statistics       │
│  - Intent        │    │  ├─ /api/conversations    │
│  - Confidence    │    │  └─ /api/log              │
│  - Response      │    │                            │
└──────────────────┘    └────────────┬───────────────┘
                                     │
                                     │ SQL Queries
                                     ▼
            ┌────────────────────────────────────────────┐
            │         MySQL DATABASE                     │
            │         (nutrition_db)                     │
            │                                            │
            │  ┌──────────────────────────────────────┐  │
            │  │  intents (13 records)                │  │
            │  │  - intent_id, intent_name            │  │
            │  └──────────────────────────────────────┘  │
            │                                            │
            │  ┌──────────────────────────────────────┐  │
            │  │  nutrition_data (700+ records)       │  │
            │  │  - user_input, intent_id, response   │  │
            │  └──────────────────────────────────────┘  │
            │                                            │
            │  ┌──────────────────────────────────────┐  │
            │  │  products (17 records)               │  │
            │  │  - product_name, calories, protein   │  │
            │  │  - carbs, fat, sugar, sodium, etc    │  │
            │  └──────────────────────────────────────┘  │
            │                                            │
            │  ┌──────────────────────────────────────┐  │
            │  │  conversation_logs                   │  │
            │  │  - session_id, user_input            │  │
            │  │  - detected_intent, confidence       │  │
            │  │  - bot_response, timestamp           │  │
            │  └──────────────────────────────────────┘  │
            │                                            │
            │  ┌──────────────────────────────────────┐  │
            │  │  user_preferences                    │  │
            │  │  - dietary_type, allergies           │  │
            │  │  - health_conditions, calorie_goal   │  │
            │  └──────────────────────────────────────┘  │
            └────────────────────────────────────────────┘
```

## Data Flow Diagram

```
User Input: "Berapa kalori Teh Botol?"
     │
     ▼
[RASA Server] receives message
     │
     ▼
[NLUCommandAdapter] → POST to External NLU Service
     │
     ▼
[External NLU Service]
  1. Analyze text with BERT model
  2. Search dataset_gizi.csv
  3. Returns: {
       "intent": "tanya_info_gizi_produk",
       "confidence": 0.95,
       "response": "Teh Botol Sosro 350 ml mengandung ±140 kkal."
     }
     │
     ▼
[RASA] receives intent & confidence
     │
     ▼
[Dialogue Management] selects action
     │
     ▼
[Action Server] executes ActionGetProductInfo
     │
     ▼
[Database API] GET /api/product?name=Teh%20Botol
     │
     ▼
[MySQL] SELECT * FROM products WHERE product_name LIKE '%Teh Botol%'
     │
     ▼
Returns: {
  "product_name": "Teh Botol Sosro",
  "calories": 140,
  "sugar": 32,
  "serving_size": "350",
  "serving_unit": "ml"
}
     │
     ▼
[Action Server] formats response
     │
     ▼
[RASA] sends to user
     │
     ▼
User sees: "📊 Informasi Gizi Teh Botol Sosro:
           • Kalori: 140 kkal
           • Gula: 32g
           • Takaran saji: 350 ml"
     │
     ▼
[Action Server] logs conversation to database
     │
     ▼
[MySQL] INSERT INTO conversation_logs (...)
```

## Database Entity Relationship Diagram

```
┌─────────────────────┐
│      intents        │
├─────────────────────┤
│ PK: intent_id       │
│     intent_name     │
│     description     │
│     created_at      │
│     updated_at      │
└──────────┬──────────┘
           │
           │ 1:N
           │
┌──────────▼──────────────┐
│   nutrition_data        │
├─────────────────────────┤
│ PK: id                  │
│ FK: intent_id           │◄─────────┐
│     user_input (TEXT)   │          │
│     response (TEXT)     │          │
│     created_at          │          │
│     updated_at          │          │
└─────────────────────────┘          │
                                     │ Referenced by
                                     │
                        ┌────────────┴──────────────┐
                        │  conversation_logs        │
                        ├───────────────────────────┤
                        │ PK: log_id                │
                        │     session_id            │
                        │     user_input            │
                        │     detected_intent       │
                        │     confidence_score      │
                        │     bot_response          │
                        │     response_time_ms      │
                        │     created_at            │
                        └───────────────────────────┘

┌─────────────────────────────────────────────┐
│              products                       │
├─────────────────────────────────────────────┤
│ PK: product_id                              │
│     product_name                            │
│     category                                │
│     calories, protein, carbohydrates        │
│     sugar, fat, saturated_fat, trans_fat    │
│     fiber, sodium, calcium, iron            │
│     vitamin_a, vitamin_c, vitamin_d         │
│     vitamin_b12, omega3, potassium          │
│     serving_size, serving_unit              │
│     created_at, updated_at                  │
└─────────────────────────────────────────────┘

┌───────────────────────────┐
│   user_preferences        │
├───────────────────────────┤
│ PK: user_id               │
│     session_id (UNIQUE)   │
│     dietary_type          │
│     allergies             │
│     health_conditions     │
│     daily_calorie_goal    │
│     age, gender           │
│     activity_level        │
│     created_at            │
│     updated_at            │
└───────────────────────────┘
```

## Technology Stack

```
Frontend Layer:
├─ Web Browser
├─ Mobile App
├─ Command Line Interface
└─ Messaging Platforms (Facebook, Telegram, etc.)

Application Layer:
├─ RASA Framework (Python)
│  ├─ NLU Pipeline (External NLU via HTTP)
│  ├─ Dialogue Management (Policies)
│  └─ Action Server (Custom Actions)
│
├─ External NLU Service (Python + FastAPI)
│  ├─ Transformers (BERT)
│  ├─ PyTorch
│  └─ CSV Dataset Processing
│
└─ Database API Service (Python + FastAPI)
   ├─ mysql-connector-python
   ├─ Pydantic (Data Validation)
   └─ Uvicorn (ASGI Server)

Data Layer:
└─ MySQL Database
   ├─ InnoDB Storage Engine
   ├─ UTF-8 Character Set
   ├─ Full-Text Search Indexes
   └─ Foreign Key Constraints
```

## Port Allocation

```
┌───────────────────────────────────────────────┐
│ Service                    │ Port   │ Protocol│
├────────────────────────────┼────────┼─────────┤
│ MySQL Database             │ 3306   │ TCP     │
│ External NLU Service       │ 3000   │ HTTP    │
│ RASA Server                │ 5005   │ HTTP    │
│ RASA Action Server         │ 5055   │ HTTP    │
│ Database API Service       │ 8000   │ HTTP    │
│ phpMyAdmin                 │ 80/443 │ HTTP(S) │
└────────────────────────────┴────────┴─────────┘
```

## API Request/Response Examples

### 1. Search Nutrition Data

**Request:**
```http
GET /api/search?q=kalori&limit=5 HTTP/1.1
Host: localhost:8000
```

**Response:**
```json
{
  "query": "kalori",
  "total_results": 5,
  "results": [
    {
      "id": 51,
      "user_input": "Berapa kebutuhan kalori saya per hari?",
      "intent": "tanya_kalori_harian",
      "response": "Rata-rata orang dewasa butuh 2000–2500 kkal/hari."
    }
  ]
}
```

### 2. Get Product Information

**Request:**
```http
GET /api/product?name=Teh%20Botol HTTP/1.1
Host: localhost:8000
```

**Response:**
```json
{
  "product": "Teh Botol",
  "found": true,
  "total_results": 1,
  "results": [
    {
      "product_name": "Teh Botol Sosro",
      "category": "Minuman",
      "calories": 140,
      "protein": 0,
      "carbohydrates": 32,
      "sugar": 32,
      "fat": 0,
      "sodium": 30,
      "serving_size": "350",
      "serving_unit": "ml"
    }
  ]
}
```

### 3. Database Statistics

**Request:**
```http
GET /api/statistics HTTP/1.1
Host: localhost:8000
```

**Response:**
```json
{
  "total_nutrition_data": 750,
  "total_products": 17,
  "total_conversations": 142,
  "intent_statistics": [
    {
      "intent_name": "tanya_info_gizi_produk",
      "total_entries": 150,
      "unique_questions": 145
    }
  ]
}
```

## File Organization

```
new-tugas2/
│
├── database/                    # ← NEW Database Integration
│   ├── create_nutrition_db.sql  # Database schema
│   ├── import_data.py           # CSV importer
│   ├── api_service.py           # FastAPI service
│   ├── test_connection.py       # Connection test
│   ├── test_queries.sql         # SQL test queries
│   ├── QUICK_TEST.sql          # Quick test commands
│   ├── requirements.txt         # Python dependencies
│   ├── README.md               # Database documentation
│   ├── SETUP_GUIDE.md          # Setup instructions
│   └── PROJECT_SUMMARY.md      # Project overview
│
├── external-nlu-service/
│   ├── nutrition_nlu_interpreter.py
│   └── train_nutrition_nlu_model.py
│
├── rasa-project/
│   ├── actions/
│   │   └── actions.py          # ← UPDATED with DB integration
│   ├── data/
│   ├── config.yml
│   ├── domain.yml
│   └── endpoints.yml
│
└── dataset_gizi.csv            # Source data (700+ rows)
```

---

**Architecture is complete and ready for deployment!** 🚀
