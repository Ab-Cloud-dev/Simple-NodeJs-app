const express = require('express');
const path = require('path');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files
app.use(express.static('public'));

// API endpoint
app.get('/api/info', (req, res) => {
    res.json({
        message: 'Hello from Simple Web App!',
        hostname: os.hostname(),
        platform: os.platform(),
        uptime: process.uptime(),
        timestamp: new Date().toISOString()
    });
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({ status: 'healthy' });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});