# Update package list
sudo apt update

# Upgrade existing packages
sudo apt upgrade -y

# Install essential tools
sudo apt install -y curl  build-essential nginx


 Download and run NodeSource setup script
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -

# Install Node.js
sudo apt install -y nodejs

# Create a system user for the app (no login shell)
sudo useradd -r -m -d /home/webapp -s /bin/bash webapp

# Create application directory
sudo mkdir -p /opt/simple-webapp

# Set ownership
sudo chown -R webapp:webapp /opt/simple-webapp

sudo apt update



# Navigate to app directory
cd /opt/simple-webapp

# Install dependencies as webapp user
sudo -u webapp npm install


##Create Systemd Service

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
