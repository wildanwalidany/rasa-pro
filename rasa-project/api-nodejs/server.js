const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// Request logging middleware
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Import routes
const giziRoutes = require('./routes/gizi');

// Use routes
app.use('/api/gizi', giziRoutes);

// Root endpoint
app.get('/', (req, res) => {
    res.json({
        message: '🍎 Nutrition API Server is running!',
        version: '1.0.0',
        database: 'gizi_database',
        endpoints: {
            'GET /': 'API Info',
            'GET /api/gizi/health': 'Health Check',
            'POST /api/gizi/produk': 'Cari informasi gizi produk',
            'POST /api/gizi/kalori-harian': 'Cari kebutuhan kalori harian',
            'GET /api/gizi/produk/all': 'Lihat semua produk (limit 10)'
        },
        example_requests: {
            'Cari Produk': {
                method: 'POST',
                url: '/api/gizi/produk',
                body: { nama_produk: 'teh botol sosro' }
            },
            'Cari Kalori': {
                method: 'POST',
                url: '/api/gizi/kalori-harian',
                body: { kategori_usia: 'dewasa', jenis_kelamin: 'wanita' }
            }
        }
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error('💥 Server Error:', err.stack);
    res.status(500).json({
        status: 'error',
        message: 'Terjadi kesalahan pada server',
        error: process.env.NODE_ENV === 'development' ? err.message : 'Internal Server Error'
    });
});

// 404 handler - FIXED: menggunakan callback function yang benar
app.use((req, res, next) => {
    res.status(404).json({
        status: 'error',
        message: `Endpoint '${req.originalUrl}' tidak ditemukan`,
        available_endpoints: [
            'GET /',
            'GET /health',
            'GET /api/gizi/health',
            'POST /api/gizi/produk',
            'POST /api/gizi/kalori-harian',
            'GET /api/gizi/produk/all'
        ]
    });
});

// Start server
app.listen(PORT, () => {
    console.log('🚀 ====================================');
    console.log(`🍎 Nutrition API Server berjalan!`);
    console.log(`📍 URL: http://localhost:${PORT}`);
    console.log(`🗄️ Database: gizi_database`);
    console.log(`⏰ Started: ${new Date().toISOString()}`);
    console.log('🚀 ====================================');
    console.log('\n🔗 Available Endpoints:');
    console.log(`   GET  http://localhost:${PORT}/`);
    console.log(`   GET  http://localhost:${PORT}/health`);
    console.log(`   POST http://localhost:${PORT}/api/gizi/produk`);
    console.log(`   POST http://localhost:${PORT}/api/gizi/kalori-harian`);
    console.log(`   GET  http://localhost:${PORT}/api/gizi/produk/all`);
    console.log('\n✅ Ready to accept requests!\n');
});