# 🍎 Nutrition Database Integration Guide

## 📋 Overview

This guide explains how to set up and integrate the MySQL database with the RASA nutrition chatbot system.

## 🗄️ Database Architecture

```
nutrition_db/
├── intents                 (13 intent types)
├── nutrition_data          (700+ Q&A records from CSV)
├── products               (Sample nutrition products)
├── conversation_logs      (User interaction logs)
└── user_preferences       (User dietary preferences)
```

## 🚀 Quick Start

### 1. Create Database in phpMyAdmin

1. Open phpMyAdmin: `http://localhost/phpmyadmin`
2. Click on "SQL" tab
3. Copy and paste the entire content from `create_nutrition_db.sql`
4. Click "Go" to execute
5. Verify database creation in left sidebar

### 2. Import CSV Data

```bash
cd database
python import_data.py
```

### 3. Start Database API Service

```bash
cd database
python api_service.py
```

API will be available at: `http://localhost:8000`
- Swagger docs: `http://localhost:8000/docs`
- ReDoc: `http://localhost:8000/redoc`

## 🧪 SQL Test Commands for phpMyAdmin

### Basic Tests

#### 1. View All Intents
```sql
SELECT * FROM intents;
```

Expected: 13 intents (greeting, goodbye, tanya_info_gizi_produk, etc.)

#### 2. Count Nutrition Data Records
```sql
SELECT COUNT(*) as total_records FROM nutrition_data;
```

Expected: Should match the number of rows in dataset_gizi.csv

#### 3. View Sample Nutrition Data
```sql
SELECT 
    n.id,
    n.user_input,
    i.intent_name,
    n.response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
LIMIT 10;
```

#### 4. View All Products
```sql
SELECT 
    product_name,
    category,
    calories,
    protein,
    carbohydrates,
    fat
FROM products
ORDER BY product_name;
```

Expected: 17 sample products

### Search Tests

#### 5. Search for "kalori" Questions
```sql
SELECT 
    user_input,
    response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%kalori%'
LIMIT 5;
```

#### 6. Search for Product "Teh Botol"
```sql
SELECT 
    product_name,
    CONCAT(calories, ' kkal') as kalori,
    CONCAT(sugar, 'g') as gula,
    CONCAT(serving_size, ' ', serving_unit) as takaran_saji
FROM products
WHERE product_name LIKE '%Teh Botol%';
```

Expected Result:
```
product_name: Teh Botol Sosro
kalori: 140 kkal
gula: 32g
takaran_saji: 350 ml
```

#### 7. Search Greeting Responses
```sql
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'greeting'
LIMIT 10;
```

### Statistical Tests

#### 8. Intent Distribution
```sql
SELECT * FROM intent_statistics
ORDER BY total_entries DESC;
```

#### 9. Most Common Intent
```sql
SELECT 
    i.intent_name,
    COUNT(*) as count
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
GROUP BY i.intent_name
ORDER BY count DESC
LIMIT 5;
```

#### 10. Products by Category
```sql
SELECT 
    category,
    COUNT(*) as total_products,
    AVG(calories) as avg_calories
FROM products
GROUP BY category;
```

### Advanced Tests

#### 11. High-Calorie Products
```sql
SELECT 
    product_name,
    category,
    calories,
    CONCAT(serving_size, ' ', serving_unit) as serving
FROM products
WHERE calories > 200
ORDER BY calories DESC;
```

#### 12. Low-Sugar Products
```sql
SELECT 
    product_name,
    sugar,
    calories
FROM products
WHERE sugar < 10 OR sugar IS NULL
ORDER BY sugar ASC;
```

#### 13. Full-Text Search Test
```sql
SELECT 
    user_input,
    response
FROM nutrition_data
WHERE MATCH(user_input) AGAINST('diet sehat' IN NATURAL LANGUAGE MODE)
LIMIT 5;
```

### Stored Procedure Tests

#### 14. Test Search Nutrition Data Procedure
```sql
CALL search_nutrition_data('kalori harian');
```

#### 15. Test Get Product Nutrition Procedure
```sql
CALL get_product_nutrition('Indomie');
```

Expected: Nutrition information for Indomie Goreng

#### 16. Test Get Intent by Name
```sql
CALL get_intent_by_name('tanya_info_gizi_produk');
```

### Conversation Logging Tests

#### 17. Insert Test Conversation
```sql
CALL log_conversation(
    'test_session_123',
    'Berapa kalori Teh Botol?',
    'tanya_info_gizi_produk',
    0.95,
    'Teh Botol Sosro 350 ml mengandung ±140 kkal.',
    120
);
```

#### 18. View Recent Conversations
```sql
SELECT 
    session_id,
    user_input,
    detected_intent,
    confidence_score,
    created_at
FROM conversation_logs
ORDER BY created_at DESC
LIMIT 10;
```

#### 19. Conversation Statistics
```sql
SELECT 
    detected_intent,
    COUNT(*) as total_queries,
    AVG(confidence_score) as avg_confidence,
    AVG(response_time_ms) as avg_response_time
FROM conversation_logs
GROUP BY detected_intent
ORDER BY total_queries DESC;
```

### Data Validation Tests

#### 20. Check for Missing Data
```sql
SELECT 
    'nutrition_data' as table_name,
    COUNT(*) as empty_responses
FROM nutrition_data
WHERE response IS NULL OR response = ''

UNION ALL

SELECT 
    'products' as table_name,
    COUNT(*) as missing_calories
FROM products
WHERE calories IS NULL;
```

#### 21. Check Intent Coverage
```sql
SELECT 
    i.intent_name,
    COUNT(n.id) as data_count,
    CASE 
        WHEN COUNT(n.id) = 0 THEN 'No Data'
        WHEN COUNT(n.id) < 10 THEN 'Low'
        WHEN COUNT(n.id) < 50 THEN 'Medium'
        ELSE 'High'
    END as coverage_level
FROM intents i
LEFT JOIN nutrition_data n ON i.intent_id = n.intent_id
GROUP BY i.intent_id, i.intent_name
ORDER BY data_count DESC;
```

#### 22. Duplicate Detection
```sql
SELECT 
    user_input,
    COUNT(*) as occurrences
FROM nutrition_data
GROUP BY user_input
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
```

### Performance Tests

#### 23. Table Sizes
```sql
SELECT 
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as size_mb
FROM information_schema.TABLES
WHERE table_schema = 'nutrition_db'
ORDER BY (data_length + index_length) DESC;
```

#### 24. Index Usage
```sql
SHOW INDEX FROM nutrition_data;
```

### Export Tests

#### 25. Export Greeting Data
```sql
SELECT 
    n.user_input as 'User Input',
    n.response as 'Response'
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'greeting'
INTO OUTFILE '/tmp/greetings_export.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
```
Note: You may need to adjust permissions for OUTFILE.

## 🔍 Testing Database API

### Using curl

```bash
# Health check
curl http://localhost:8000/health

# Search nutrition data
curl "http://localhost:8000/api/search?q=kalori&limit=5"

# Get product info
curl "http://localhost:8000/api/product?name=Teh%20Botol"

# Get all intents
curl http://localhost:8000/api/intents

# Get statistics
curl http://localhost:8000/api/statistics

# Get recent conversations
curl http://localhost:8000/api/conversations?limit=10

# Get all products
curl "http://localhost:8000/api/products?limit=20"
```

### Using Python

```python
import requests

# Search
response = requests.get(
    "http://localhost:8000/api/search",
    params={"q": "kalori", "limit": 5}
)
print(response.json())

# Get product
response = requests.get(
    "http://localhost:8000/api/product",
    params={"name": "Teh Botol"}
)
print(response.json())
```

## 🔗 Integration with RASA

### 1. Update endpoints.yml

```yaml
action_endpoint:
  url: "http://localhost:5055/webhook"
```

### 2. Start Action Server

```bash
cd rasa-project
rasa run actions
```

### 3. Test Integration

```bash
rasa shell
```

Example conversation:
```
You: Halo
Bot: Halo! Ada yang bisa saya bantu terkait informasi gizi?

You: Berapa kalori Teh Botol?
Bot: 📊 Informasi Gizi Teh Botol Sosro:
     • Kalori: 140 kkal
     • Gula: 32g
     • Takaran saji: 350 ml
```

## 📊 Expected Results Summary

| Test | Expected Result |
|------|----------------|
| Total Intents | 13 |
| Sample Products | 17 |
| Nutrition Data Records | 700+ (from CSV) |
| Teh Botol Calories | 140 kkal |
| Indomie Goreng Sodium | 730 mg |
| Yakult Sugar | 10g |

## 🛠️ Troubleshooting

### Cannot connect to database
```sql
-- Check MySQL is running
SHOW DATABASES;

-- Check user permissions
SHOW GRANTS FOR 'root'@'localhost';
```

### Import fails
```python
# Check CSV file path
import os
print(os.path.exists('dataset_gizi.csv'))
```

### API not responding
```bash
# Check if port 8000 is in use
netstat -ano | findstr :8000

# Or use different port
uvicorn api_service:app --port 8001
```

## 📈 Next Steps

1. ✅ Database created and populated
2. ✅ API service running
3. ✅ RASA integration configured
4. 🔄 Add more products to database
5. 🔄 Implement user preferences
6. 🔄 Add analytics dashboard

## 📝 Notes

- All timestamps are in UTC
- Text encoding is UTF-8 (utf8mb4)
- InnoDB engine for ACID compliance
- Full-text indexes for fast searching
- Foreign keys for data integrity

## 🎯 Quick Verification Checklist

```sql
-- Run this complete verification query
SELECT 'Database Setup Complete!' as status,
       (SELECT COUNT(*) FROM intents) as total_intents,
       (SELECT COUNT(*) FROM nutrition_data) as total_nutrition_data,
       (SELECT COUNT(*) FROM products) as total_products,
       (SELECT COUNT(*) FROM conversation_logs) as total_conversations;
```

Expected output:
```
status: Database Setup Complete!
total_intents: 13
total_nutrition_data: 700+ 
total_products: 17
total_conversations: 0 (initially)
```

---

**Ready to test!** 🚀

Start with the basic tests above, then move to advanced queries as needed.
