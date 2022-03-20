#!/usr/bin/env bash

curl -fsSL https://deb.nodesource.com/setup_14.x | sudo -E bash -

sudo apt-get install -y nodejs

sudo npm -g install yarn

yarn global add code-server

if [[ -f "$HOME/.config/code-server/config.yaml" ]]; then
    rm -f $HOME/.config/code-server/config.yaml
    touch $HOME/.config/code-server/config.yaml
fi
tee -a $HOME/.config/code-server/config.yaml >/dev/null <<EOF
bind-addr: 0.0.0.0:8080
auth: password
password: changeme
cert: false
EOF

if [[ -f "/etc/systemd/system/code-server.service" ]]; then
    sudo rm -f /etc/systemd/system/code-server.service
    sudo touch /etc/systemd/system/code-server.service
fi
sudo tee -a /etc/systemd/system/code-server.service >/dev/null <<EOF
[Unit]
Description=code-server
After=network.target

[Service]
User=$USER
Group=$USER

WorkingDirectory=/home/$USER
Environment="PATH=/usr/bin"
ExecStart=/home/$USER/.yarn/bin/code-server

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable code-server

sudo systemctl restart code-server