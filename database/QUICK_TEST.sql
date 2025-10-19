-- ================================================================
-- QUICK SQL TEST COMMANDS FOR PHPMYADMIN
-- Copy and paste these commands one by one to test the database
-- ================================================================

-- ----------------------------------------------------------------
-- STEP 1: SELECT DATABASE
-- ----------------------------------------------------------------
USE nutrition_db;


-- ----------------------------------------------------------------
-- STEP 2: BASIC VERIFICATION (Run these first!)
-- ----------------------------------------------------------------

-- Test 2.1: Count all tables
SHOW TABLES;
-- Expected: 5 tables

-- Test 2.2: Quick status check
SELECT 
    (SELECT COUNT(*) FROM intents) as total_intents,
    (SELECT COUNT(*) FROM nutrition_data) as total_nutrition_data,
    (SELECT COUNT(*) FROM products) as total_products;
-- Expected: 13, 700+, 17

-- Test 2.3: View all intents
SELECT * FROM intents ORDER BY intent_name;
-- Expected: 13 rows


-- ----------------------------------------------------------------
-- STEP 3: PRODUCT TESTS (Most Important!)
-- ----------------------------------------------------------------

-- Test 3.1: Teh Botol Sosro
SELECT * FROM products WHERE product_name = 'Teh Botol Sosro';
-- Expected: 140 kkal, 32g sugar

-- Test 3.2: Indomie Goreng
SELECT * FROM products WHERE product_name = 'Indomie Goreng';
-- Expected: 390 kkal, 730mg sodium

-- Test 3.3: Yakult
SELECT * FROM products WHERE product_name = 'Yakult';
-- Expected: 50 kkal, 10g sugar

-- Test 3.4: All products summary
SELECT 
    product_name,
    CONCAT(calories, ' kkal') as calories,
    CONCAT(sugar, 'g') as sugar,
    CONCAT(sodium, 'mg') as sodium
FROM products
ORDER BY product_name;
-- Expected: 17 products


-- ----------------------------------------------------------------
-- STEP 4: SEARCH TESTS
-- ----------------------------------------------------------------

-- Test 4.1: Search for "kalori" questions
SELECT user_input, response 
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%kalori%'
LIMIT 5;

-- Test 4.2: Search for "diet" questions
SELECT user_input, response 
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE user_input LIKE '%diet%'
LIMIT 5;


-- ----------------------------------------------------------------
-- STEP 5: STORED PROCEDURE TESTS
-- ----------------------------------------------------------------

-- Test 5.1: Search nutrition data
CALL search_nutrition_data('kalori harian');

-- Test 5.2: Get product nutrition - Teh Botol
CALL get_product_nutrition('Teh Botol');

-- Test 5.3: Get product nutrition - Indomie
CALL get_product_nutrition('Indomie');


-- ----------------------------------------------------------------
-- STEP 6: STATISTICS TESTS
-- ----------------------------------------------------------------

-- Test 6.1: Intent statistics
SELECT * FROM intent_statistics ORDER BY total_entries DESC;

-- Test 6.2: Product categories
SELECT 
    category,
    COUNT(*) as total_products,
    ROUND(AVG(calories), 0) as avg_calories
FROM products
GROUP BY category;


-- ----------------------------------------------------------------
-- STEP 7: SAMPLE DATA TESTS
-- ----------------------------------------------------------------

-- Test 7.1: View greeting responses
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'greeting'
LIMIT 10;

-- Test 7.2: View goodbye responses
SELECT user_input, response
FROM nutrition_data n
JOIN intents i ON n.intent_id = i.intent_id
WHERE i.intent_name = 'goodbye'
LIMIT 10;


-- ----------------------------------------------------------------
-- STEP 8: CONVERSATION LOGGING TEST
-- ----------------------------------------------------------------

-- Test 8.1: Log a sample conversation
CALL log_conversation(
    'test_session_001',
    'Berapa kalori Teh Botol Sosro?',
    'tanya_info_gizi_produk',
    0.95,
    'Teh Botol Sosro 350 ml mengandung ±140 kkal.',
    120
);

-- Test 8.2: View logged conversations
SELECT * FROM conversation_logs ORDER BY created_at DESC LIMIT 10;


-- ----------------------------------------------------------------
-- STEP 9: ADVANCED QUERIES
-- ----------------------------------------------------------------

-- Test 9.1: High calorie products (>200 kkal)
SELECT 
    product_name,
    calories,
    CONCAT(serving_size, ' ', serving_unit) as serving
FROM products
WHERE calories > 200
ORDER BY calories DESC;

-- Test 9.2: Low sugar products (<15g)
SELECT 
    product_name,
    sugar,
    calories
FROM products
WHERE sugar < 15
ORDER BY sugar ASC;


-- ----------------------------------------------------------------
-- STEP 10: FINAL HEALTH CHECK
-- ----------------------------------------------------------------

-- Complete database verification
SELECT 
    '✓ Database is healthy!' as status,
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
    ) as database_size;


-- ================================================================
-- EXPECTED RESULTS SUMMARY
-- ================================================================
/*
✓ intents: 13
✓ nutrition_data: 700+ records
✓ products: 17 items
✓ conversations: 0 initially, then increases with usage

Product Tests:
✓ Teh Botol Sosro: 140 kkal, 32g sugar, 350ml
✓ Indomie Goreng: 390 kkal, 730mg sodium, 85g
✓ Yakult: 50 kkal, 10g sugar, 65ml
✓ Pop Mie: 360 kkal
✓ Coca Cola: 105 kkal, 26g sugar, 250ml
*/

-- ================================================================
-- IF ALL TESTS PASS: Database is ready! 🎉
-- ================================================================
