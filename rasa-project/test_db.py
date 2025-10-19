import mysql.connector
from mysql.connector import Error

def test_gizi_database():
    """Test koneksi ke database gizi_database"""
    try:
        connection = mysql.connector.connect(
            host='localhost',
            database='gizi_database',  # Updated database name
            user='root',
            password='',
            port=3306
        )
        
        if connection.is_connected():
            print("✅ Koneksi ke database 'gizi_database' berhasil!")
            
            cursor = connection.cursor()
            
            # Test tabel produk_gizi
            cursor.execute("SELECT COUNT(*) FROM produk_gizi")
            produk_count = cursor.fetchone()[0]
            print(f"📊 Jumlah produk dalam database: {produk_count}")
            
            # Test beberapa produk
            cursor.execute("SELECT nama_produk FROM produk_gizi LIMIT 5")
            products = [row[0] for row in cursor.fetchall()]
            print(f"🍎 Contoh produk: {', '.join(products)}")
            
            # Test tabel kebutuhan_kalori
            cursor.execute("SELECT COUNT(*) FROM kebutuhan_kalori")
            kalori_count = cursor.fetchone()[0]
            print(f"📈 Jumlah data kalori harian: {kalori_count}")
            
            # Test search produk
            test_product = "teh botol sosro"
            cursor.execute("SELECT nama_produk, kalori FROM produk_gizi WHERE LOWER(nama_produk) LIKE %s", (f'%{test_product}%',))
            result = cursor.fetchone()
            if result:
                print(f"🔍 Test search '{test_product}': {result[0]} - {result[1]} kkal")
            
            cursor.close()
            connection.close()
            print("✅ Test database berhasil!")
            
    except Error as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    test_gizi_database()