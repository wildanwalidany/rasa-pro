"""
Import Nutrition Dataset from CSV to MySQL Database
Reads dataset_gizi.csv and populates the nutrition_db database
"""

import csv
import mysql.connector
from mysql.connector import Error
import os
from datetime import datetime

# Database configuration
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root',  # Change this to your MySQL username
    'password': '',  # Change this to your MySQL password
    'database': 'nutrition_db',
    'charset': 'utf8mb4',
    'collation': 'utf8mb4_unicode_ci'
}

def connect_to_database():
    """Connect to MySQL database"""
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            print("✓ Successfully connected to MySQL database")
            return connection
    except Error as e:
        print(f"✗ Error connecting to MySQL: {e}")
        return None

def get_intent_id(cursor, intent_name):
    """Get intent_id for a given intent name"""
    cursor.execute("SELECT intent_id FROM intents WHERE intent_name = %s", (intent_name,))
    result = cursor.fetchone()
    return result[0] if result else None

def import_csv_to_database(csv_file_path):
    """Import CSV data into nutrition_data table"""
    connection = connect_to_database()
    if not connection:
        return
    
    try:
        cursor = connection.cursor()
        
        # Check if data already exists
        cursor.execute("SELECT COUNT(*) FROM nutrition_data")
        existing_count = cursor.fetchone()[0]
        
        if existing_count > 0:
            print(f"\n⚠ Warning: Database already contains {existing_count} records.")
            response = input("Do you want to clear existing data and reimport? (yes/no): ")
            if response.lower() == 'yes':
                cursor.execute("DELETE FROM nutrition_data")
                connection.commit()
                print("✓ Cleared existing data")
            else:
                print("✗ Import cancelled")
                return
        
        # Read CSV file
        if not os.path.exists(csv_file_path):
            print(f"✗ CSV file not found: {csv_file_path}")
            return
        
        print(f"\n📂 Reading CSV file: {csv_file_path}")
        
        with open(csv_file_path, 'r', encoding='utf-8') as file:
            csv_reader = csv.DictReader(file)
            
            insert_query = """
                INSERT INTO nutrition_data (user_input, intent_id, response)
                VALUES (%s, %s, %s)
            """
            
            imported_count = 0
            skipped_count = 0
            
            for row in csv_reader:
                user_input = row['User Input'].strip()
                intent_name = row['Intent'].strip()
                response = row['Response'].strip()
                
                # Get intent_id
                intent_id = get_intent_id(cursor, intent_name)
                
                if not intent_id:
                    print(f"⚠ Warning: Intent '{intent_name}' not found in database. Skipping row.")
                    skipped_count += 1
                    continue
                
                # Insert data
                cursor.execute(insert_query, (user_input, intent_id, response))
                imported_count += 1
                
                # Show progress every 100 rows
                if imported_count % 100 == 0:
                    print(f"  Imported {imported_count} records...")
            
            # Commit all changes
            connection.commit()
            
            print(f"\n✓ Import completed successfully!")
            print(f"  • Total imported: {imported_count} records")
            print(f"  • Skipped: {skipped_count} records")
            
            # Show statistics
            print("\n📊 Database Statistics:")
            cursor.execute("SELECT * FROM intent_statistics")
            stats = cursor.fetchall()
            
            print("\n  Intent Name                    | Total Entries | Unique Questions")
            print("  " + "-" * 75)
            for stat in stats:
                print(f"  {stat[0]:<30} | {stat[2]:>13} | {stat[3]:>16}")
        
    except Error as e:
        print(f"✗ Error importing data: {e}")
        connection.rollback()
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()
            print("\n✓ Database connection closed")

def verify_database():
    """Verify database contents"""
    connection = connect_to_database()
    if not connection:
        return
    
    try:
        cursor = connection.cursor()
        
        print("\n" + "=" * 80)
        print("DATABASE VERIFICATION")
        print("=" * 80)
        
        # Check intents
        cursor.execute("SELECT COUNT(*) FROM intents")
        intent_count = cursor.fetchone()[0]
        print(f"\n✓ Intents table: {intent_count} intents")
        
        # Check nutrition data
        cursor.execute("SELECT COUNT(*) FROM nutrition_data")
        data_count = cursor.fetchone()[0]
        print(f"✓ Nutrition data table: {data_count} records")
        
        # Check products
        cursor.execute("SELECT COUNT(*) FROM products")
        product_count = cursor.fetchone()[0]
        print(f"✓ Products table: {product_count} products")
        
        # Sample data
        print("\n📝 Sample Records:")
        cursor.execute("""
            SELECT n.user_input, i.intent_name, n.response 
            FROM nutrition_data n
            JOIN intents i ON n.intent_id = i.intent_id
            LIMIT 5
        """)
        samples = cursor.fetchall()
        
        for idx, sample in enumerate(samples, 1):
            print(f"\n{idx}. User Input: {sample[0]}")
            print(f"   Intent: {sample[1]}")
            print(f"   Response: {sample[2][:100]}...")
        
    except Error as e:
        print(f"✗ Error verifying database: {e}")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

def test_queries():
    """Run test queries to verify functionality"""
    connection = connect_to_database()
    if not connection:
        return
    
    try:
        cursor = connection.cursor()
        
        print("\n" + "=" * 80)
        print("RUNNING TEST QUERIES")
        print("=" * 80)
        
        # Test 1: Search nutrition data
        print("\n🔍 Test 1: Search for 'kalori'")
        cursor.callproc('search_nutrition_data', ['kalori'])
        for result in cursor.stored_results():
            rows = result.fetchall()
            print(f"   Found {len(rows)} results")
            if rows:
                print(f"   First result: {rows[0][1][:50]}...")
        
        # Test 2: Get product nutrition
        print("\n🔍 Test 2: Get nutrition for 'Teh Botol'")
        cursor.callproc('get_product_nutrition', ['Teh Botol'])
        for result in cursor.stored_results():
            rows = result.fetchall()
            if rows:
                for row in rows:
                    print(f"   Product: {row[0]}")
                    print(f"   Calories: {row[2]}, Protein: {row[3]}")
        
        # Test 3: Intent statistics
        print("\n📊 Test 3: Intent Statistics")
        cursor.execute("SELECT * FROM intent_statistics LIMIT 5")
        stats = cursor.fetchall()
        for stat in stats:
            print(f"   {stat[0]}: {stat[2]} entries")
        
    except Error as e:
        print(f"✗ Error running test queries: {e}")
    
    finally:
        if connection.is_connected():
            cursor.close()
            connection.close()

if __name__ == "__main__":
    print("=" * 80)
    print("NUTRITION DATABASE IMPORT TOOL")
    print("=" * 80)
    
    # Path to CSV file
    csv_file = os.path.join(os.path.dirname(__file__), '..', 'dataset_gizi.csv')
    
    # Import data
    import_csv_to_database(csv_file)
    
    # Verify database
    verify_database()
    
    # Run test queries
    test_queries()
    
    print("\n" + "=" * 80)
    print("✓ ALL OPERATIONS COMPLETED")
    print("=" * 80)
