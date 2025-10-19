"""
Quick Database Connection Test
Run this to verify your database is set up correctly
"""

import mysql.connector
from mysql.connector import Error

def test_connection():
    """Test database connection"""
    print("=" * 60)
    print("TESTING DATABASE CONNECTION")
    print("=" * 60)
    
    config = {
        'host': 'localhost',
        'user': 'root',
        'password': '',  # Change if you have a password
        'database': 'nutrition_db',
        'charset': 'utf8mb4'
    }
    
    try:
        print("\n1. Connecting to MySQL...")
        connection = mysql.connector.connect(**config)
        
        if connection.is_connected():
            print("   ✓ Connected successfully!")
            
            cursor = connection.cursor()
            
            # Test 1: Check database
            print("\n2. Checking database...")
            cursor.execute("SELECT DATABASE()")
            db = cursor.fetchone()
            print(f"   ✓ Current database: {db[0]}")
            
            # Test 2: Count tables
            print("\n3. Checking tables...")
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            print(f"   ✓ Found {len(tables)} tables:")
            for table in tables:
                print(f"     - {table[0]}")
            
            # Test 3: Count intents
            print("\n4. Checking intents...")
            cursor.execute("SELECT COUNT(*) FROM intents")
            count = cursor.fetchone()[0]
            print(f"   ✓ Total intents: {count}")
            
            # Test 4: Count nutrition data
            print("\n5. Checking nutrition data...")
            cursor.execute("SELECT COUNT(*) FROM nutrition_data")
            count = cursor.fetchone()[0]
            print(f"   ✓ Total nutrition records: {count}")
            
            # Test 5: Count products
            print("\n6. Checking products...")
            cursor.execute("SELECT COUNT(*) FROM products")
            count = cursor.fetchone()[0]
            print(f"   ✓ Total products: {count}")
            
            # Test 6: Sample query
            print("\n7. Testing sample query...")
            cursor.execute("""
                SELECT n.user_input, i.intent_name, n.response 
                FROM nutrition_data n
                JOIN intents i ON n.intent_id = i.intent_id
                LIMIT 1
            """)
            sample = cursor.fetchone()
            if sample:
                print(f"   ✓ Sample record:")
                print(f"     Input: {sample[0][:50]}...")
                print(f"     Intent: {sample[1]}")
                print(f"     Response: {sample[2][:50]}...")
            
            # Test 7: Test stored procedure
            print("\n8. Testing stored procedure...")
            try:
                cursor.callproc('search_nutrition_data', ['kalori'])
                print("   ✓ Stored procedures are working!")
            except Error as e:
                print(f"   ⚠ Stored procedure error: {e}")
            
            print("\n" + "=" * 60)
            print("✓ ALL TESTS PASSED!")
            print("=" * 60)
            print("\nYour database is ready to use!")
            print("\nNext steps:")
            print("1. Run: python import_data.py (if not done)")
            print("2. Run: python api_service.py")
            print("3. Visit: http://localhost:8000/docs")
            
    except Error as e:
        print(f"\n✗ ERROR: {e}")
        print("\nTroubleshooting:")
        print("1. Make sure MySQL is running")
        print("2. Check username and password in config")
        print("3. Run create_nutrition_db.sql in phpMyAdmin first")
        
    finally:
        if connection and connection.is_connected():
            cursor.close()
            connection.close()
            print("\n✓ Connection closed")

if __name__ == "__main__":
    test_connection()
