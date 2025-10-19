-- =========================================================
-- NUTRITION DATABASE CREATION SCRIPT
-- Based on dataset_gizi.csv
-- Date: 2025-10-19
-- =========================================================

-- Create database
CREATE DATABASE IF NOT EXISTS nutrition_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE nutrition_db;

-- =========================================================
-- TABLE: intents
-- Stores all intent types
-- =========================================================
CREATE TABLE IF NOT EXISTS intents (
    intent_id INT AUTO_INCREMENT PRIMARY KEY,
    intent_name VARCHAR(100) NOT NULL UNIQUE,
    intent_description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_intent_name (intent_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- TABLE: nutrition_data
-- Main table storing all nutrition questions and responses
-- =========================================================
CREATE TABLE IF NOT EXISTS nutrition_data (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_input TEXT NOT NULL,
    intent_id INT NOT NULL,
    response TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (intent_id) REFERENCES intents(intent_id) ON DELETE CASCADE,
    INDEX idx_intent_id (intent_id),
    FULLTEXT INDEX idx_user_input (user_input),
    FULLTEXT INDEX idx_response (response)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- TABLE: products
-- Stores nutrition information for specific food products
-- =========================================================
CREATE TABLE IF NOT EXISTS products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    calories DECIMAL(10, 2),
    protein DECIMAL(10, 2),
    carbohydrates DECIMAL(10, 2),
    sugar DECIMAL(10, 2),
    fat DECIMAL(10, 2),
    saturated_fat DECIMAL(10, 2),
    trans_fat DECIMAL(10, 2),
    fiber DECIMAL(10, 2),
    sodium DECIMAL(10, 2),
    calcium DECIMAL(10, 2),
    iron DECIMAL(10, 2),
    vitamin_a DECIMAL(10, 2),
    vitamin_c DECIMAL(10, 2),
    vitamin_d DECIMAL(10, 2),
    vitamin_b12 DECIMAL(10, 2),
    omega3 DECIMAL(10, 2),
    potassium DECIMAL(10, 2),
    serving_size VARCHAR(50),
    serving_unit VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_product_name (product_name),
    INDEX idx_category (category),
    FULLTEXT INDEX idx_product_search (product_name, category)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- TABLE: conversation_logs
-- Stores all user conversations for analytics
-- =========================================================
CREATE TABLE IF NOT EXISTS conversation_logs (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100),
    user_input TEXT NOT NULL,
    detected_intent VARCHAR(100),
    confidence_score DECIMAL(5, 4),
    bot_response TEXT,
    response_time_ms INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_session_id (session_id),
    INDEX idx_created_at (created_at),
    INDEX idx_detected_intent (detected_intent)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- TABLE: user_preferences
-- Stores user dietary preferences and restrictions
-- =========================================================
CREATE TABLE IF NOT EXISTS user_preferences (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100) UNIQUE,
    dietary_type VARCHAR(50), -- vegetarian, vegan, halal, etc.
    allergies TEXT,
    health_conditions TEXT,
    daily_calorie_goal INT,
    age INT,
    gender ENUM('male', 'female', 'other'),
    activity_level ENUM('sedentary', 'light', 'moderate', 'active', 'very_active'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_session_id (session_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =========================================================
-- INSERT INTENTS
-- =========================================================
INSERT INTO intents (intent_name, intent_description) VALUES
('greeting', 'Salam pembuka dan sapaan'),
('goodbye', 'Salam penutup dan perpisahan'),
('tanya_info_gizi_produk', 'Pertanyaan tentang informasi gizi produk tertentu'),
('tanya_kalori_harian', 'Pertanyaan tentang kebutuhan kalori harian'),
('tanya_rekomendasi_makanan', 'Permintaan rekomendasi makanan sehat'),
('tanya_kandungan_zat', 'Pertanyaan tentang kandungan zat gizi tertentu'),
('tanya_porsi_makan', 'Pertanyaan tentang porsi makan yang sehat'),
('tanya_label_gizi', 'Pertanyaan tentang cara membaca label gizi'),
('tanya_makanan_diet', 'Pertanyaan tentang makanan untuk diet tertentu'),
('tanya_efek_kesehatan', 'Pertanyaan tentang efek kesehatan dari makanan'),
('tanya_alternatif_makanan', 'Pertanyaan tentang alternatif makanan sehat'),
('tanya_waktu_makan', 'Pertanyaan tentang waktu makan yang tepat'),
('tanya_tips_hidup_sehat', 'Pertanyaan tentang tips hidup sehat');

-- =========================================================
-- VIEW: intent_statistics
-- Summary of intent usage for analytics
-- =========================================================
CREATE OR REPLACE VIEW intent_statistics AS
SELECT 
    i.intent_name,
    i.intent_description,
    COUNT(n.id) as total_entries,
    COUNT(DISTINCT n.user_input) as unique_questions
FROM intents i
LEFT JOIN nutrition_data n ON i.intent_id = n.intent_id
GROUP BY i.intent_id, i.intent_name, i.intent_description
ORDER BY total_entries DESC;

-- =========================================================
-- VIEW: popular_products
-- Most queried nutrition products
-- =========================================================
CREATE OR REPLACE VIEW popular_products AS
SELECT 
    product_name,
    category,
    calories,
    protein,
    carbohydrates,
    fat,
    COUNT(*) as query_count
FROM products
GROUP BY product_id, product_name, category, calories, protein, carbohydrates, fat
ORDER BY query_count DESC;

-- =========================================================
-- STORED PROCEDURE: search_nutrition_data
-- Search nutrition data by keyword
-- =========================================================
DELIMITER //
CREATE PROCEDURE search_nutrition_data(IN search_term VARCHAR(255))
BEGIN
    SELECT 
        n.id,
        n.user_input,
        i.intent_name,
        n.response
    FROM nutrition_data n
    JOIN intents i ON n.intent_id = i.intent_id
    WHERE MATCH(n.user_input) AGAINST(search_term IN NATURAL LANGUAGE MODE)
       OR n.user_input LIKE CONCAT('%', search_term, '%')
    ORDER BY 
        MATCH(n.user_input) AGAINST(search_term IN NATURAL LANGUAGE MODE) DESC
    LIMIT 10;
END //
DELIMITER ;

-- =========================================================
-- STORED PROCEDURE: get_product_nutrition
-- Get nutrition info for a specific product
-- =========================================================
DELIMITER //
CREATE PROCEDURE get_product_nutrition(IN product_search VARCHAR(255))
BEGIN
    SELECT 
        product_name,
        category,
        CONCAT(calories, ' kkal') as calories,
        CONCAT(protein, 'g') as protein,
        CONCAT(carbohydrates, 'g') as carbohydrates,
        CONCAT(sugar, 'g') as sugar,
        CONCAT(fat, 'g') as fat,
        CONCAT(sodium, 'mg') as sodium,
        serving_size,
        serving_unit
    FROM products
    WHERE MATCH(product_name) AGAINST(product_search IN NATURAL LANGUAGE MODE)
       OR product_name LIKE CONCAT('%', product_search, '%')
    LIMIT 5;
END //
DELIMITER ;

-- =========================================================
-- STORED PROCEDURE: log_conversation
-- Log user conversation
-- =========================================================
DELIMITER //
CREATE PROCEDURE log_conversation(
    IN p_session_id VARCHAR(100),
    IN p_user_input TEXT,
    IN p_detected_intent VARCHAR(100),
    IN p_confidence DECIMAL(5,4),
    IN p_bot_response TEXT,
    IN p_response_time INT
)
BEGIN
    INSERT INTO conversation_logs (
        session_id, 
        user_input, 
        detected_intent, 
        confidence_score, 
        bot_response, 
        response_time_ms
    ) VALUES (
        p_session_id,
        p_user_input,
        p_detected_intent,
        p_confidence,
        p_bot_response,
        p_response_time
    );
END //
DELIMITER ;

-- =========================================================
-- STORED PROCEDURE: get_intent_by_name
-- Get intent ID by name
-- =========================================================
DELIMITER //
CREATE PROCEDURE get_intent_by_name(IN intent_name_param VARCHAR(100))
BEGIN
    SELECT intent_id, intent_name, intent_description
    FROM intents
    WHERE intent_name = intent_name_param;
END //
DELIMITER ;

-- =========================================================
-- TEST QUERIES
-- Run these to verify database is working correctly
-- =========================================================

-- Test 1: Show all intents
-- SELECT * FROM intents;

-- Test 2: Show intent statistics
-- SELECT * FROM intent_statistics;

-- Test 3: Search for nutrition data (after importing from CSV)
-- CALL search_nutrition_data('kalori');

-- Test 4: Get product nutrition (after adding products)
-- CALL get_product_nutrition('Teh Botol');

-- Test 5: Show recent conversations (after logging some)
-- SELECT * FROM conversation_logs ORDER BY created_at DESC LIMIT 10;

-- =========================================================
-- SAMPLE PRODUCT DATA INSERTION
-- Add some sample products based on dataset
-- =========================================================
INSERT INTO products (product_name, category, calories, protein, carbohydrates, sugar, fat, sodium, serving_size, serving_unit) VALUES
('Teh Botol Sosro', 'Minuman', 140, 0, 32, 32, 0, 30, '350', 'ml'),
('Ultra Milk Strawberry', 'Minuman Susu', 110, 6, 17, 17, 4, 80, '200', 'ml'),
('Aqua', 'Air Mineral', 0, 0, 0, 0, 0, 0, '600', 'ml'),
('Pop Mie Rasa Ayam', 'Mie Instan', 360, 8, 50, 3, 14, 1200, '75', 'gram'),
('Indomie Goreng', 'Mie Instan', 390, 9, 58, 2, 14, 730, '85', 'gram'),
('Coca Cola', 'Minuman Bersoda', 105, 0, 26, 26, 0, 35, '250', 'ml'),
('Silverqueen', 'Coklat', 140, 2, 12, 12, 8, 20, '25', 'gram'),
('Oreo', 'Biskuit', 140, 2, 20, 12, 6, 120, '28', 'gram'),
('Nutrisari Jeruk', 'Minuman Serbuk', 60, 0, 15, 15, 0, 10, '14', 'gram'),
('Yakult', 'Minuman Probiotik', 50, 1, 10, 10, 1, 20, '65', 'ml'),
('Chitato', 'Keripik', 360, 4, 48, 1, 18, 400, '68', 'gram'),
('Good Day Cappuccino', 'Kopi Instan', 110, 1, 18, 18, 4, 60, '20', 'gram'),
('Fruit Tea Apel', 'Teh Buah', 150, 0, 36, 36, 0, 25, '350', 'ml'),
('Frestea Green Tea', 'Teh', 180, 0, 42, 42, 0, 30, '500', 'ml'),
('Pocari Sweat', 'Minuman Isotonik', 80, 0, 20, 20, 0, 150, '350', 'ml'),
('Bear Brand', 'Susu', 120, 7, 10, 10, 6, 90, '189', 'ml'),
('Milo UHT', 'Susu Coklat', 140, 5, 20, 20, 4, 100, '200', 'ml');

-- =========================================================
-- GRANT PRIVILEGES (adjust username/password as needed)
-- =========================================================
-- CREATE USER IF NOT EXISTS 'nutrition_user'@'localhost' IDENTIFIED BY 'nutrition_pass123';
-- GRANT ALL PRIVILEGES ON nutrition_db.* TO 'nutrition_user'@'localhost';
-- FLUSH PRIVILEGES;

-- =========================================================
-- END OF SCRIPT
-- =========================================================
