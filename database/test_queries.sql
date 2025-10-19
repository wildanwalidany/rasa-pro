-- =========================================================
-- NUTRITION DATABASE TEST COMMANDS
-- Copy and paste these into phpMyAdmin SQL tab
-- =========================================================

USE nutrition_db;

-- =========================================================
-- SECTION 1: BASIC VERIFICATION TESTS
-- =========================================================

-- Test 1.1: Show all tables
SHOW TABLES;

-- Test 1.2: Count all intents
SELECT COUNT(*) as total_intents FROM intents;

-- Test 1.3: View all intents
SELECT * FROM intents ORDER BY intent_name;

-- Test 1.4: Count nutrition data
SELECT COUNT(*) as total_nutrition_data FROM nutrition_data;

-- Test 1.5: Count products
SELECT COUNT(*) as total_products FROM products;

-- Test 1.6: Quick status check
SELECT 
    'Database Status' as status,
    (SELECT COUNT(*) FROM intents) as total_intents,
    (SELECT COUNT(*) FROM nutrition_data) as total_nutrition_data,
    (SELECT COUNT(*) FROM products) as total_products,
    (SELECT COUNT(*) FROM conversation_logs) as total_conversations;

-- =========================================================
-- SECTION 2: DATA EXPLORATION TESTS
-- =========================================================

-- Test 2.1: View first 10 nutrition records
SELECT 
    n.id,
    n.user_input,
    i.intent_name,
    LEFT(n.response, 50) as response_preview
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
LIMIT 10;

-- Test 2.2: View all products with nutrition info
SELECT 
    product_name,
    category,
    CONCAT(calories, ' kkal') as calories,
    CONCAT(protein, 'g') as protein,
    CONCAT(carbohydrates, 'g') as carbs,
    CONCAT(fat, 'g') as fat,
    CONCAT(serving_size, ' ', serving_unit) as serving
FROM products
ORDER BY product_name;

-- Test 2.3: Intent distribution statistics
SELECT * FROM intent_statistics ORDER BY total_entries DESC;

-- =========================================================
-- SECTION 3: SEARCH TESTS
-- =========================================================

-- Test 3.1: Search for "kalori" questions
SELECT 
    user_input,
    LEFT(response, 100) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%kalori%'
LIMIT 10;

-- Test 3.2: Search for "diet" questions
SELECT 
    user_input,
    i.intent_name,
    LEFT(response, 100) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%diet%'
LIMIT 10;

-- Test 3.3: Find product "Teh Botol"
SELECT * FROM products WHERE product_name LIKE '%Teh Botol%';

-- Test 3.4: Find product "Indomie"
SELECT 
    product_name,
    CONCAT(calories, ' kkal') as kalori,
    CONCAT(sodium, ' mg') as natrium,
    CONCAT(fat, 'g') as lemak
FROM products 
WHERE product_name LIKE '%Indomie%';

-- Test 3.5: Full-text search test (if available)
SELECT 
    user_input,
    response
FROM nutrition_data
WHERE MATCH(user_input) AGAINST('protein sehat' IN NATURAL LANGUAGE MODE)
LIMIT 5;

-- =========================================================
-- SECTION 4: GREETING & GOODBYE TESTS
-- =========================================================

-- Test 4.1: All greeting responses
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'greeting'
LIMIT 20;

-- Test 4.2: All goodbye responses
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'goodbye'
LIMIT 20;

-- =========================================================
-- SECTION 5: PRODUCT INFORMATION TESTS
-- =========================================================

-- Test 5.1: High-calorie products (>200 kkal)
SELECT 
    product_name,
    category,
    calories,
    CONCAT(serving_size, ' ', serving_unit) as serving
FROM products
WHERE calories > 200
ORDER BY calories DESC;

-- Test 5.2: Low-sugar products (<15g)
SELECT 
    product_name,
    sugar,
    calories
FROM products
WHERE sugar < 15
ORDER BY sugar ASC;

-- Test 5.3: High-protein products
SELECT 
    product_name,
    protein,
    calories
FROM products
WHERE protein >= 5
ORDER BY protein DESC;

-- Test 5.4: Products by category
SELECT 
    category,
    COUNT(*) as total_products,
    AVG(calories) as avg_calories,
    AVG(sugar) as avg_sugar
FROM products
GROUP BY category
ORDER BY total_products DESC;

-- Test 5.5: Healthiest products (low sugar, low sodium)
SELECT 
    product_name,
    calories,
    sugar,
    sodium
FROM products
WHERE sugar < 15 AND sodium < 200
ORDER BY calories ASC;

-- =========================================================
-- SECTION 6: INTENT-SPECIFIC TESTS
-- =========================================================

-- Test 6.1: Info gizi produk questions
SELECT user_input, LEFT(response, 80) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'tanya_info_gizi_produk'
LIMIT 10;

-- Test 6.2: Kalori harian questions
SELECT user_input, LEFT(response, 80) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'tanya_kalori_harian'
LIMIT 10;

-- Test 6.3: Rekomendasi makanan questions
SELECT user_input, LEFT(response, 80) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'tanya_rekomendasi_makanan'
LIMIT 10;

-- Test 6.4: Tips hidup sehat questions
SELECT user_input, LEFT(response, 80) as response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'tanya_tips_hidup_sehat'
LIMIT 10;

-- =========================================================
-- SECTION 7: STORED PROCEDURE TESTS
-- =========================================================

-- Test 7.1: Search nutrition data procedure
CALL search_nutrition_data('kalori harian');

-- Test 7.2: Get product nutrition procedure
CALL get_product_nutrition('Teh Botol');

-- Test 7.3: Get product nutrition - Indomie
CALL get_product_nutrition('Indomie');

-- Test 7.4: Get product nutrition - Ultra Milk
CALL get_product_nutrition('Ultra Milk');

-- Test 7.5: Get intent by name
CALL get_intent_by_name('tanya_info_gizi_produk');

-- =========================================================
-- SECTION 8: CONVERSATION LOGGING TESTS
-- =========================================================

-- Test 8.1: Insert sample conversation log
CALL log_conversation(
    'test_session_001',
    'Berapa kalori Teh Botol Sosro?',
    'tanya_info_gizi_produk',
    0.95,
    'Teh Botol Sosro 350 ml mengandung ±140 kkal.',
    120
);

-- Test 8.2: Insert another sample conversation
CALL log_conversation(
    'test_session_001',
    'Apa rekomendasi sarapan sehat?',
    'tanya_rekomendasi_makanan',
    0.89,
    'Oatmeal dengan buah segar sangat bagus.',
    95
);

-- Test 8.3: View all conversation logs
SELECT * FROM conversation_logs ORDER BY created_at DESC LIMIT 20;

-- Test 8.4: Conversation statistics by intent
SELECT 
    detected_intent,
    COUNT(*) as total_queries,
    ROUND(AVG(confidence_score), 3) as avg_confidence,
    ROUND(AVG(response_time_ms), 0) as avg_response_time_ms
FROM conversation_logs
GROUP BY detected_intent
ORDER BY total_queries DESC;

-- Test 8.5: Conversations by session
SELECT 
    session_id,
    COUNT(*) as total_messages,
    MIN(created_at) as first_message,
    MAX(created_at) as last_message
FROM conversation_logs
GROUP BY session_id
ORDER BY total_messages DESC;

-- =========================================================
-- SECTION 9: DATA QUALITY TESTS
-- =========================================================

-- Test 9.1: Check for empty responses
SELECT COUNT(*) as empty_responses
FROM nutrition_data
WHERE response IS NULL OR response = '';

-- Test 9.2: Check for duplicate user inputs
SELECT 
    user_input,
    COUNT(*) as occurrences
FROM nutrition_data
GROUP BY user_input
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;

-- Test 9.3: Intent coverage analysis
SELECT 
    i.intent_name,
    COUNT(n.id) as data_count,
    CASE 
        WHEN COUNT(n.id) = 0 THEN '❌ No Data'
        WHEN COUNT(n.id) < 10 THEN '⚠️ Low Coverage'
        WHEN COUNT(n.id) < 50 THEN '✓ Medium Coverage'
        ELSE '✓✓ High Coverage'
    END as coverage_status
FROM intents i
LEFT JOIN nutrition_data n ON i.intent_id = n.intent_id
GROUP BY i.intent_id, i.intent_name
ORDER BY data_count DESC;

-- Test 9.4: Products with missing nutrition info
SELECT 
    product_name,
    CASE WHEN calories IS NULL THEN '❌' ELSE '✓' END as has_calories,
    CASE WHEN protein IS NULL THEN '❌' ELSE '✓' END as has_protein,
    CASE WHEN carbohydrates IS NULL THEN '❌' ELSE '✓' END as has_carbs,
    CASE WHEN fat IS NULL THEN '❌' ELSE '✓' END as has_fat
FROM products;

-- =========================================================
-- SECTION 10: PERFORMANCE & STATISTICS TESTS
-- =========================================================

-- Test 10.1: Table sizes and row counts
SELECT 
    table_name,
    table_rows,
    ROUND(((data_length + index_length) / 1024 / 1024), 2) as size_mb
FROM information_schema.TABLES
WHERE table_schema = 'nutrition_db'
ORDER BY (data_length + index_length) DESC;

-- Test 10.2: Index information
SHOW INDEX FROM nutrition_data;

-- Test 10.3: Database size
SELECT 
    ROUND(SUM(data_length + index_length) / 1024 / 1024, 2) as database_size_mb
FROM information_schema.TABLES
WHERE table_schema = 'nutrition_db';

-- =========================================================
-- SECTION 11: SPECIFIC PRODUCT TESTS
-- =========================================================

-- Test 11.1: Teh Botol Sosro full info
SELECT * FROM products WHERE product_name = 'Teh Botol Sosro';
-- Expected: 140 kkal, 32g sugar

-- Test 11.2: Indomie Goreng full info
SELECT * FROM products WHERE product_name = 'Indomie Goreng';
-- Expected: 390 kkal, 730mg sodium

-- Test 11.3: Yakult full info
SELECT * FROM products WHERE product_name = 'Yakult';
-- Expected: 50 kkal, 10g sugar

-- Test 11.4: Pop Mie full info
SELECT * FROM products WHERE product_name LIKE '%Pop Mie%';
-- Expected: 360 kkal

-- Test 11.5: Compare beverages
SELECT 
    product_name,
    calories,
    sugar,
    CONCAT(serving_size, ' ', serving_unit) as serving
FROM products
WHERE category LIKE '%Minuman%'
ORDER BY sugar DESC;

-- =========================================================
-- SECTION 12: USEFUL QUERIES FOR CHATBOT
-- =========================================================

-- Test 12.1: Get random greeting
SELECT response 
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'greeting'
ORDER BY RAND()
LIMIT 1;

-- Test 12.2: Get random goodbye
SELECT response 
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'goodbye'
ORDER BY RAND()
LIMIT 1;

-- Test 12.3: Search by keyword with intent filter
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%susu%'
AND i.intent_name = 'tanya_info_gizi_produk'
LIMIT 5;

-- =========================================================
-- FINAL VERIFICATION
-- =========================================================

-- Complete database health check
SELECT 
    '✓ Database Health Check' as status,
    (SELECT COUNT(*) FROM intents) as intents,
    (SELECT COUNT(*) FROM nutrition_data) as nutrition_data,
    (SELECT COUNT(*) FROM products) as products,
    (SELECT COUNT(*) FROM conversation_logs) as conversations,
    CONCAT(
        ROUND(
            (SELECT SUM(data_length + index_length) / 1024 / 1024 
             FROM information_schema.TABLES 
             WHERE table_schema = 'nutrition_db'), 
        2), 
        ' MB'
    ) as total_size;

-- =========================================================
-- EXPECTED RESULTS
-- =========================================================
-- intents: 13
-- nutrition_data: 700+ (depends on CSV import)
-- products: 17 (sample data)
-- conversations: 0-n (depends on usage)
-- =========================================================

-- 🎉 If all tests pass, your database is ready!
