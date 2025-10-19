const mysql = require('mysql2');

// Konfigurasi koneksi database
const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '', // sesuaikan dengan password MySQL Anda
    database: 'gizi_database',
    port: 3306,
    multipleStatements: true
};

// Membuat koneksi database
const koneksi = mysql.createConnection(dbConfig);

// Test koneksi database
koneksi.connect((err) => {
    if (err) {
        console.error('❌ Error koneksi database:', err);
        throw err;
    }
    console.log('✅ Koneksi MySQL berhasil! Database: gizi_database');
});

// Export koneksi untuk digunakan di module lain
module.exports = koneksi;