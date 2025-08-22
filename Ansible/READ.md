# Simple Web App - Ansible Deployment

## Prerequisites
- Ansible installed on your local machine
- Target server(s) running Ubuntu/Debian
- SSH access to target server(s)
- sudo privileges on target server(s)

## Setup Steps

1. **Clone or create the project structure**
   ```bash
   mkdir simple-webapp
   cd simple-webapp
   ```

2. **Configure inventory**
   Edit `ansible/inventory.ini` and update:
   - Server IP addresses
   - SSH username
   - SSH key path

3. **Test connectivity**
   ```bash
   cd ansible
   ansible -i inventory.ini all -m ping
   ```

4. **Deploy the application**
   ```bash
   ansible-playbook -i inventory.ini playbook.yml
   ```

5. **Additional options**
   ```bash
   # Run with verbose output
   ansible-playbook -i inventory.ini playbook.yml -v

   # Check mode (dry run)
   ansible-playbook -i inventory.ini playbook.yml --check

   # Deploy to specific hosts
   ansible-playbook -i inventory.ini playbook.yml --limit server1
   ```

## Customization

### Variables you can customize in playbook.yml:
- `app_port`: Port for the Node.js application (default: 3000)
- `node_version`: Node.js version to install (default: 18)
- `app_name`: Application name (default: simple-webapp)

### To deploy updates:
1. Make changes to the application code
2. Run the playbook again
3. The service will automatically restart

## Verification

After deployment, verify the application:
- Access the web interface: `http://your-server-ip`
- Check service status: `sudo systemctl status simple-webapp`
- View logs: `sudo journalctl -u simple-webapp -f`
- Health check: `curl http://your-server-ip/health`

## Troubleshooting

1. **Connection refused**
   - Check if the service is running
   - Verify firewall rules
   - Check Nginx configuration

2. **Permission denied**
   - Ensure SSH key is correct
   - Verify sudo privileges

3. **Service won't start**
   - Check logs: `sudo journalctl -u simple-webapp -n 50`
   - Verify Node.js installation
   - Check port availability

## Security Considerations
- Use strong SSH keys
- Configure firewall rules appropriately
- Consider using HTTPS with SSL certificates
- Regularly update dependencies
- Use Ansible Vault for sensitive data
```

## Quick Start Commands

```bash
# 1. Create the project structure and copy all files above

# 2. Navigate to ansible directory
cd simple-webapp/ansible

# 3. Update inventory with your server details
nano inventory.ini

# 4. Run the deployment
ansible-playbook -i inventory.ini playbook.yml

# 5. Access your application
# Open browser to: http://your-server-ip
```