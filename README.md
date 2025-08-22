# It is a Simple web-app 

<img width="1710" height="844" alt="image" src="https://github.com/user-attachments/assets/768d8785-bf4d-4227-a6e7-c4863ea14ab8" />

# For Automatic Installation

```bash

sudo sh web-app-Installation.sh

```


# Manual Deployment Steps for Ubuntu

## Prerequisites

- Ubuntu 20.04/22.04/24.04 server
- sudo privileges
- Basic familiarity with command line

## Step 1: Update System and Install Dependencies

```bash
# Update package list
sudo apt update

# Upgrade existing packages
sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl git build-essential nginx
```

## Step 2: Install Node.js (Version 18)

```bash
# Download and run NodeSource setup script
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Node.js
sudo apt install -y nodejs

# Verify installation
node --version
npm --version
```

## Step 3: Create Application User

```bash
# Create a system user for the app (no login shell)
sudo useradd -r -m -d /home/webapp -s /bin/bash webapp

# Create application directory
sudo mkdir -p /opt/simple-webapp

# Set ownership
sudo chown -R webapp:webapp /opt/simple-webapp
```

## Step 4: Create Application Files

### Option A : Clone from Git (if you have the files in a repo)

```bash
# As webapp user
sudo -u webapp git clone https://github.com/Ab-Cloud-dev/Simple-NodeJs-app.git /opt/simple-webapp
```

### Option B : Create files manually

```bash
# Switch to app directory
cd /opt/simple-webapp

# Create package.json
sudo -u webapp cat > package.json

```


```JSON
{
  "name": "simple-webapp",
  "version": "1.0.0",
  "description": "Simple web application for testing",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.18.2"
  }
}
```

```bash
# Create server.js
sudo -u webapp cat > server.js 

```

```Js

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

```

```bash
# Create public directory
sudo -u webapp mkdir -p public

# Create index.html
sudo -u webapp cat > public/index.html

```



```html

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Simple Web App</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="container">
        <h1>Simple Web Application</h1>
        <p>Manually Deployed on Ubuntu</p>

        <div class="info-card">
            <h2>Server Information</h2>
            <div id="server-info">
                <p>Loading...</p>
            </div>
            <button onclick="fetchInfo()">Refresh Info</button>
        </div>
    </div>

    <script>
        async function fetchInfo() {
            try {
                const response = await fetch('/api/info');
                const data = await response.json();

                document.getElementById('server-info').innerHTML = `
                    <p><strong>Message:</strong> ${data.message}</p>
                    <p><strong>Hostname:</strong> ${data.hostname}</p>
                    <p><strong>Platform:</strong> ${data.platform}</p>
                    <p><strong>Uptime:</strong> ${Math.floor(data.uptime)} seconds</p>
                    <p><strong>Time:</strong> ${new Date(data.timestamp).toLocaleString()}</p>
                `;
            } catch (error) {
                document.getElementById('server-info').innerHTML = 
                    '<p class="error">Error loading server info</p>';
            }
        }

        // Load info on page load
        fetchInfo();

        // Auto-refresh every 5 seconds
        setInterval(fetchInfo, 5000);
    </script>
</body>
</html>


```

# Create style.css

```bash
sudo -u webapp cat > public/style.css

```



```css
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    min-height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

.container {
    background: white;
    border-radius: 10px;
    padding: 2rem;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    max-width: 600px;
    width: 90%;
}

h1 {
    color: #333;
    margin-bottom: 0.5rem;
    text-align: center;
}

p {
    color: #666;
    text-align: center;
    margin-bottom: 2rem;
}

.info-card {
    background: #f7f7f7;
    border-radius: 8px;
    padding: 1.5rem;
}

.info-card h2 {
    color: #444;
    margin-bottom: 1rem;
    font-size: 1.2rem;
}

#server-info p {
    text-align: left;
    margin: 0.5rem 0;
    color: #555;
}

button {
    background: #667eea;
    color: white;
    border: none;
    padding: 0.75rem 1.5rem;
    border-radius: 5px;
    cursor: pointer;
    font-size: 1rem;
    margin-top: 1rem;
    width: 100%;
    transition: background 0.3s ease;
}

button:hover {
    background: #5a67d8;
}

.error {
    color: #e53e3e;
}
```



## Step 5: Install Node.js Dependencies

```bash
# Navigate to app directory
cd /opt/simple-webapp

# Install dependencies as webapp user
sudo -u webapp npm install
```

## Step 6: Test the Application Manually

```bash
# Run the app directly (for testing)
sudo -u webapp node server.js

# You should see: "Server running on port 3000"
# Press Ctrl+C to stop

# Or run in background for testing
sudo -u webapp nohup node server.js > app.log 2>&1 &

# Check if it's running
curl http://localhost:3000/health

# View the process
ps aux | grep node

# Kill the test process (replace PID with actual process ID)
# kill [PID]
```

## Step 7: Create Systemd Service

```bash
# Create log directory
sudo mkdir -p /var/log/simple-webapp
sudo chown webapp:webapp /var/log/simple-webapp

# Create service file
sudo cat > /etc/systemd/system/simple-webapp.service << 'EOF'
[Unit]
Description=Simple Web Application
After=network.target

[Service]
Type=simple
User=webapp
WorkingDirectory=/opt/simple-webapp
ExecStart=/usr/bin/node /opt/simple-webapp/server.js
Restart=always
RestartSec=10
Environment=NODE_ENV=production
Environment=PORT=3000

# Logging
StandardOutput=append:/var/log/simple-webapp/app.log
StandardError=append:/var/log/simple-webapp/error.log

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd
sudo systemctl daemon-reload

# Start the service
sudo systemctl start simple-webapp

# Enable auto-start on boot
sudo systemctl enable simple-webapp

# Check status
sudo systemctl status simple-webapp
```

## Step 8: Configure Nginx as Reverse Proxy

```bash
# Backup default config
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/default.backup

# Create new Nginx configuration
sudo cat > /etc/nginx/sites-available/simple-webapp << 'EOF'
upstream simple-webapp {
    server localhost:3000;
}

server {
    listen 80;
    server_name _;

    location / {
        proxy_pass http://simple-webapp;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Remove default site and enable new one
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/simple-webapp /etc/nginx/sites-enabled/

# Test Nginx configuration
sudo nginx -t

# Restart Nginx
sudo systemctl restart nginx
```

## Step 9: Configure Firewall (Optional but Recommended)

```bash
# If using ufw (Ubuntu Firewall)
sudo ufw allow 22/tcp  # SSH
sudo ufw allow 80/tcp  # HTTP
sudo ufw allow 443/tcp # HTTPS (for future)

# Enable firewall (be careful if on SSH!)
sudo ufw --force enable

# Check status
sudo ufw status
```

## Step 10: Verify Everything is Working

```bash
# Check service status
sudo systemctl status simple-webapp

# Check if port 3000 is listening
sudo netstat -tlpn | grep 3000

# Check Nginx status
sudo systemctl status nginx

# Test health endpoint
curl http://localhost/health

# Check logs
sudo journalctl -u simple-webapp -n 50

# Or check log files directly
sudo tail -f /var/log/simple-webapp/app.log
```

## Testing from Browser

1. Open your browser
2. Navigate to: `http://YOUR_SERVER_IP`
3. You should see the web application with auto-updating server info

## Useful Commands for Management

```bash
# Service Management
sudo systemctl start simple-webapp    # Start service
sudo systemctl stop simple-webapp     # Stop service
sudo systemctl restart simple-webapp  # Restart service
sudo systemctl status simple-webapp   # Check status

# View Logs
sudo journalctl -u simple-webapp -f   # Follow logs
sudo tail -f /var/log/simple-webapp/app.log  # App logs
sudo tail -f /var/log/nginx/error.log # Nginx errors

# Update Application
cd /opt/simple-webapp
sudo -u webapp git pull  # If using git
sudo systemctl restart simple-webapp

# Monitor Resources
htop  # Interactive process viewer
df -h # Disk usage
free -m # Memory usage
```

## Troubleshooting

### App won't start

```bash
# Check port availability
sudo lsof -i :3000

# Check Node.js installation
node --version
which node

# Check permissions
ls -la /opt/simple-webapp

# Run manually to see errors
cd /opt/simple-webapp
sudo -u webapp node server.js
```

### Nginx issues

```bash
# Test configuration
sudo nginx -t

# Check error logs
sudo tail -f /var/log/nginx/error.log

# Restart Nginx
sudo systemctl restart nginx
```

### Can't access from browser

```bash
# Check if services are running
sudo systemctl status simple-webapp
sudo systemctl status nginx

# Check firewall
sudo ufw status

# Test locally
curl http://localhost
curl http://localhost:3000/health

# Check listening ports
sudo netstat -tlpn
```

## Clean Up (If Needed)

```bash
# Stop services
sudo systemctl stop simple-webapp
sudo systemctl stop nginx

# Disable services
sudo systemctl disable simple-webapp

# Remove files
sudo rm -rf /opt/simple-webapp
sudo rm /etc/systemd/system/simple-webapp.service
sudo rm /etc/nginx/sites-available/simple-webapp
sudo rm /etc/nginx/sites-enabled/simple-webapp

# Remove user
sudo userdel -r webapp

# Reload systemd
sudo systemctl daemon-reload
```

## Notes

- Default app runs on port 3000 internally
- Nginx proxies port 80 to port 3000
- Logs are in `/var/log/simple-webapp/`
- Service auto-restarts on crash
- All app files owned by `webapp` user for security
- Consider adding SSL/HTTPS for production use
