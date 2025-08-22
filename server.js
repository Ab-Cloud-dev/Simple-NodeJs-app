const express = require('express');
const path = require('path');
const os = require('os');

const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from the "public" folder
app.use(express.static(path.join(__dirname, 'public')));

// Root route – if index.html exists in "public", it will be served automatically.
// This route acts as a fallback welcome message if no index.html is present.
app.get('/', (req, res) => {
    res.send('<h1>Welcome to the Simple Web App</h1><p>Visit <a href="/api/info">/api/info</a> for API details or <a href="/health">/health</a> for health check.</p>');
});

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

// 404 handler for undefined routes
app.use((req, res) => {
    res.status(404).send({ error: 'Not Found' });
});

app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
