const express = require('express');
const router = express.Router();
const db = require('../config/database');

// API untuk mencari informasi gizi produk
router.post('/produk', (req, res) => {
    const { nama_produk } = req.body;
    
    if (!nama_produk) {
        return res.status(400).json({
            status: 'error',
            message: 'Nama produk harus diisi'
        });
    }
    
    const query = `
        SELECT nama_produk, kalori, protein, lemak, karbohidrat, gula, natrium, 
               serat, vitamin_c, kalsium, zat_besi, takaran_saji, kategori 
        FROM produk_gizi 
        WHERE LOWER(nama_produk) LIKE LOWER(?)
        ORDER BY 
            CASE 
                WHEN LOWER(nama_produk) = LOWER(?) THEN 1
                WHEN LOWER(nama_produk) LIKE LOWER(?) THEN 2
                ELSE 3
            END
        LIMIT 1
    `;
    
    const searchTerm = `%${nama_produk}%`;
    const exactTerm = nama_produk;
    const startTerm = `${nama_produk}%`;
    
    db.query(query, [searchTerm, exactTerm, startTerm], (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                status: 'error',
                message: 'Terjadi kesalahan pada database'
            });
        }
        
        if (results.length > 0) {
            res.json({
                status: 'success',
                data: results[0],
                message: 'Produk ditemukan'
            });
        } else {
            res.status(404).json({
                status: 'not_found',
                message: 'Produk tidak ditemukan dalam database'
            });
        }
    });
});

// API untuk kebutuhan kalori harian
router.post('/kalori-harian', (req, res) => {
    const { kategori_usia, jenis_kelamin } = req.body;
    
    if (!kategori_usia) {
        return res.status(400).json({
            status: 'error',
            message: 'Kategori usia harus diisi'
        });
    }
    
    let query = `
        SELECT kategori_usia, jenis_kelamin, min_kalori, max_kalori, aktivitas_level
        FROM kebutuhan_kalori 
        WHERE LOWER(kategori_usia) LIKE LOWER(?)
    `;
    
    let queryParams = [`%${kategori_usia}%`];
    
    if (jenis_kelamin) {
        query += ` AND jenis_kelamin = ?`;
        queryParams.push(jenis_kelamin);
    }
    
    query += ` ORDER BY CASE jenis_kelamin WHEN 'umum' THEN 1 ELSE 2 END LIMIT 1`;
    
    db.query(query, queryParams, (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                status: 'error',
                message: 'Terjadi kesalahan pada database'
            });
        }
        
        if (results.length > 0) {
            res.json({
                status: 'success',
                data: results[0],
                message: 'Data kalori harian ditemukan'
            });
        } else {
            res.status(404).json({
                status: 'not_found',
                message: 'Data kalori harian tidak ditemukan'
            });
        }
    });
});

// API untuk mendapatkan semua produk (untuk testing)
router.get('/produk/all', (req, res) => {
    const query = 'SELECT nama_produk, kalori, kategori FROM produk_gizi ORDER BY nama_produk';
    
    db.query(query, (err, results) => {
        if (err) {
            console.error('Database error:', err);
            return res.status(500).json({
                status: 'error',
                message: 'Terjadi kesalahan pada database'
            });
        }
        
        res.json({
            status: 'success',
            data: results,
            total: results.length,
            message: 'Data produk berhasil diambil'
        });
    });
});

module.exports = router;