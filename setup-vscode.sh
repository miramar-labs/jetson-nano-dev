#!/usr/bin/env bash


# NOTE: works best in firefox


curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo npm -g install yarn

yarn global add code-server

if [[ -f "/etc/systemd/system/code-server.service" ]]; then
    sudo rm -f /etc/systemd/system/code-server.service
fi
sudo touch /etc/systemd/system/code-server.service
sudo tee -a /etc/systemd/system/code-server.service >/dev/null <<EOF
[Unit]
Description=code-server
After=network.target

[Service]
User=$USER
Group=$USER

WorkingDirectory=/home/$USER
Environment="PATH=/usr/bin"
ExecStart=/home/$USER/.yarn/bin/code-server --cert

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable code-server

sudo systemctl restart code-server