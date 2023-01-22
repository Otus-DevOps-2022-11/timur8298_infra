#!/bin/bash
apt-get update && apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git
cd reddit && bundle install
cat <<EOF> /etc/systemd/system/puma.service

[Unit]
Description=Puma
After=network.target

[Service]
Type=simple
WorkingDirectory=/home/ubuntu/reddit
ExecStart=/usr/local/bin/puma
Restart=always

[Install]
WantedBy=multi-user.target
EOF
systemctl enable puma
