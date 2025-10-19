# 📋 Project Summary: RASA Nutrition Chatbot with Database Integration

## ✅ Completed Components

### 1. Database Layer (NEW)
- ✅ `create_nutrition_db.sql` - Complete database schema
- ✅ `import_data.py` - CSV to database import tool
- ✅ `api_service.py` - FastAPI REST API service
- ✅ `test_connection.py` - Database connectivity test
- ✅ `test_queries.sql` - Comprehensive SQL test queries
- ✅ `requirements.txt` - Python dependencies
- ✅ `README.md` - Database documentation
- ✅ `SETUP_GUIDE.md` - Complete setup instructions

### 2. Database Schema
**Tables Created:**
- `intents` (13 intent types)
- `nutrition_data` (main Q&A data from CSV)
- `products` (17 sample products with nutrition facts)
- `conversation_logs` (user interaction tracking)
- `user_preferences` (dietary preferences storage)

**Views Created:**
- `intent_statistics` - Intent usage analytics
- `popular_products` - Most queried products

**Stored Procedures:**
- `search_nutrition_data(search_term)` - Search Q&A data
- `get_product_nutrition(product_name)` - Get product info
- `log_conversation(...)` - Log conversations
- `get_intent_by_name(intent_name)` - Get intent details

### 3. API Endpoints (Port 8000)
- `GET /health` - Health check
- `GET /api/search` - Search nutrition data
- `GET /api/product` - Get product information
- `GET /api/intents` - List all intents
- `GET /api/statistics` - Database statistics
- `GET /api/conversations` - Recent conversations
- `GET /api/products` - List products
- `POST /api/log` - Log conversation

### 4. Integration with RASA
- ✅ Updated `actions/actions.py` with database integration
- ✅ Custom actions for database queries
- ✅ Conversation logging
- ✅ Product information retrieval

## 🗄️ Database Structure

```sql
nutrition_db
├── intents (13 rows)
│   ├── intent_id (PK)
│   ├── intent_name
│   └── intent_description
│
├── nutrition_data (700+ rows from CSV)
│   ├── id (PK)
│   ├── user_input
│   ├── intent_id (FK)
│   └── response
│
├── products (17 sample rows)
│   ├── product_id (PK)
│   ├── product_name
│   ├── category
│   ├── calories, protein, carbohydrates
│   ├── sugar, fat, sodium
│   └── vitamins & minerals
│
├── conversation_logs
│   ├── log_id (PK)
│   ├── session_id
│   ├── user_input
│   ├── detected_intent
│   ├── confidence_score
│   ├── bot_response
│   └── response_time_ms
│
└── user_preferences
    ├── user_id (PK)
    ├── session_id
    ├── dietary_type
    ├── allergies
    └── health_conditions
```

## 🧪 SQL Test Commands for phpMyAdmin

### Quick Verification
```sql
USE nutrition_db;

-- Check database status
SELECT 
    (SELECT COUNT(*) FROM intents) as intents,
    (SELECT COUNT(*) FROM nutrition_data) as nutrition_data,
    (SELECT COUNT(*) FROM products) as products;
```

### Search Tests
```sql
-- Find "Teh Botol" nutrition info
SELECT * FROM products WHERE product_name LIKE '%Teh Botol%';
-- Expected: 140 kkal, 32g sugar

-- Search for "kalori" questions
CALL search_nutrition_data('kalori');

-- Get product nutrition
CALL get_product_nutrition('Indomie');
-- Expected: 390 kkal, 730mg sodium
```

### Statistics Tests
```sql
-- Intent distribution
SELECT * FROM intent_statistics;

-- Product categories
SELECT category, COUNT(*) as total 
FROM products 
GROUP BY category;
```

### Conversation Logging Test
```sql
-- Log a test conversation
CALL log_conversation(
    'test_001',
    'Berapa kalori Teh Botol?',
    'tanya_info_gizi_produk',
    0.95,
    'Teh Botol Sosro 350 ml mengandung ±140 kkal.',
    120
);

-- View logged conversations
SELECT * FROM conversation_logs ORDER BY created_at DESC LIMIT 10;
```

## 🎯 Expected Test Results

| Test | Expected Result |
|------|----------------|
| Total Intents | 13 |
| Nutrition Data Records | 700+ (from CSV) |
| Sample Products | 17 |
| Teh Botol Sosro Calories | 140 kkal |
| Teh Botol Sosro Sugar | 32g |
| Indomie Goreng Calories | 390 kkal |
| Indomie Goreng Sodium | 730 mg |
| Yakult Calories | 50 kkal |
| Yakult Sugar | 10g |
| Pop Mie Calories | 360 kkal |

## 🚀 Service Architecture

```
┌─────────────────┐
│  User/Client    │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────┐
│     RASA Server (Port 5005)         │
│  ┌──────────────────────────────┐   │
│  │   NLU Command Adapter        │   │
│  └──────────┬───────────────────┘   │
└─────────────┼───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  External NLU Service (Port 3000)   │
│  (nutrition_nlu_interpreter.py)     │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  RASA Action Server (Port 5055)     │
│  ┌──────────────────────────────┐   │
│  │  Custom Actions              │   │
│  │  - ActionSearchNutrition     │   │
│  │  - ActionGetProductInfo      │   │
│  │  - ActionLogConversation     │   │
│  └──────────┬───────────────────┘   │
└─────────────┼───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│  Database API Service (Port 8000)   │
│  (FastAPI - api_service.py)         │
└─────────────┬───────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│     MySQL Database                  │
│     (nutrition_db)                  │
└─────────────────────────────────────┘
```

## 📦 Files Created

```
database/
├── create_nutrition_db.sql      (400+ lines)
├── import_data.py              (220+ lines)
├── api_service.py              (400+ lines)
├── test_connection.py          (120+ lines)
├── test_queries.sql            (500+ lines)
├── requirements.txt
├── README.md                   (600+ lines)
└── SETUP_GUIDE.md             (400+ lines)
```

## 🔧 Installation Commands

```bash
# 1. Create database in phpMyAdmin
# Copy/paste create_nutrition_db.sql

# 2. Install dependencies
cd database
pip install -r requirements.txt

# 3. Import CSV data
python import_data.py

# 4. Test connection
python test_connection.py

# 5. Start API service
python api_service.py
```

## 🧪 Quick Test in phpMyAdmin

Copy this into phpMyAdmin SQL tab:

```sql
-- Quick test script
USE nutrition_db;

-- 1. Database status
SELECT 'Database Status Check' as test;
SELECT COUNT(*) as intents FROM intents;
SELECT COUNT(*) as nutrition_data FROM nutrition_data;
SELECT COUNT(*) as products FROM products;

-- 2. Sample data
SELECT 'Sample Nutrition Data' as test;
SELECT user_input, response FROM nutrition_data LIMIT 3;

-- 3. Product test
SELECT 'Product: Teh Botol Sosro' as test;
SELECT * FROM products WHERE product_name LIKE '%Teh Botol%';

-- 4. Search test
SELECT 'Search: kalori' as test;
CALL search_nutrition_data('kalori');

-- 5. Statistics
SELECT 'Intent Statistics' as test;
SELECT * FROM intent_statistics LIMIT 5;

-- ✅ All tests complete!
```

## 📊 Sample Data in Database

### Products Table (17 items)
- Teh Botol Sosro (140 kkal)
- Ultra Milk Strawberry (110 kkal)
- Indomie Goreng (390 kkal)
- Pop Mie Rasa Ayam (360 kkal)
- Coca Cola (105 kkal)
- Yakult (50 kkal)
- And 11 more...

### Intents Table (13 intents)
1. greeting
2. goodbye
3. tanya_info_gizi_produk
4. tanya_kalori_harian
5. tanya_rekomendasi_makanan
6. tanya_kandungan_zat
7. tanya_porsi_makan
8. tanya_label_gizi
9. tanya_makanan_diet
10. tanya_efek_kesehatan
11. tanya_alternatif_makanan
12. tanya_waktu_makan
13. tanya_tips_hidup_sehat

## 🎉 What You Can Do Now

1. ✅ Run all SQL tests in phpMyAdmin
2. ✅ Search nutrition data via database
3. ✅ Get product information via API
4. ✅ Log user conversations
5. ✅ Analyze user interaction patterns
6. ✅ Track popular queries
7. ✅ Export data for analysis

## 📚 Documentation

- **Database Schema**: See `create_nutrition_db.sql`
- **Test Queries**: See `test_queries.sql`
- **Setup Guide**: See `SETUP_GUIDE.md`
- **API Docs**: http://localhost:8000/docs (when running)
- **Database Guide**: See `README.md`

## ✨ Key Features

1. **Full Database Integration**
   - MySQL database with comprehensive schema
   - Stored procedures for common operations
   - Full-text search support
   - Conversation logging

2. **REST API Service**
   - FastAPI-based service
   - Swagger/OpenAPI documentation
   - CORS enabled for web integration
   - Health monitoring

3. **RASA Integration**
   - Custom actions for database queries
   - Conversation logging
   - Product information retrieval
   - Statistics tracking

4. **Analytics & Reporting**
   - Intent usage statistics
   - User interaction patterns
   - Popular product queries
   - Confidence score tracking

## 🔍 Next Steps

1. Import CSV data: `python import_data.py`
2. Test database: Run SQL queries in phpMyAdmin
3. Start API: `python api_service.py`
4. Test API: Visit http://localhost:8000/docs
5. Integrate with RASA: Update endpoints and test

---

**All components are ready for testing!** 🚀

Use `test_queries.sql` for comprehensive SQL testing in phpMyAdmin.
