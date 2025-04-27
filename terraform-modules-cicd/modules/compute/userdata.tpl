#!/bin/bash
sudo apt update
sudo apt install -y python3 python3-pip python3-virtualenv nginx jq

# Create backend directory
mkdir -p /home/ubuntu/backend
cd /home/ubuntu/backend

# Create main.py file with content
cat > main.py << 'EOL'
${backend_main_py}
EOL

# Create requirements.txt file with content
cat > requirements.txt << 'EOL'
${backend_requirements}
EOL

# Replace SELECTED_REGION in main.py with the current instance's region
sed -i "s/SELECTED_REGION/$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r '.region')/g" main.py

# Create an Nginx configuration file
cat << 'EOF' > /etc/nginx/sites-available/fastapi
server {
    listen 80;
    server_name ~.;
    location / {
        proxy_pass http://localhost:8000;
    }
}
EOF

# Enable the Nginx configuration and restart Nginx
sudo ln -s /etc/nginx/sites-available/fastapi /etc/nginx/sites-enabled/
sudo systemctl restart nginx

# Set up Python virtual environment
virtualenv .venv
source .venv/bin/activate

# Install required Python packages
pip install -r requirements.txt

# Start the FastAPI application as a service
cat > /etc/systemd/system/fastapi.service << 'EOF'
[Unit]
Description=FastAPI application
After=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/backend
Environment="PATH=/home/ubuntu/backend/.venv/bin"
ExecStart=/home/ubuntu/backend/.venv/bin/uvicorn main:app --host 0.0.0.0 --port 8000

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the service
sudo systemctl enable fastapi
sudo systemctl start fastapi