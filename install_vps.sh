#!/bin/bash
# Overlord Ultimate Cluster VPS Installer v14.0
# Kompatibel mit Ubuntu 20.04+, Debian 11+

echo "=== 🛰️ STARTING VPS DEPLOYMENT & AUTO-CONFIGURATION ==="
sudo apt-get update -y && sudo apt-get upgrade -y

echo "[1/4] Installiere grundlegende System-Utilities..."
sudo apt-get install -y python3-pip python3-venv python3-dev git gcc make curl

echo "[2/4] Klone Workspace / Erstelle App-Verzeichnis..."
mkdir -p /opt/overlord-control
cd /opt/overlord-control

echo "[3/4] Erstelle virtuelle Python-Umgebung & installiere Abhängigkeiten..."
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install gradio psutil requests paramiko torch

echo "[4/4] Konfiguriere Autostart via Systemd Daemon..."
sudo bash -c 'cat <<EOF > /etc/systemd/system/overlord-control.service
[Unit]
Description=Overlord Control Center Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/overlord-control
ExecStart=/opt/overlord-control/venv/bin/python main.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable overlord-control.service

echo "=== 🟢 INSTALLATION ABGESCHLOSSEN ==="
echo "Kopiere deine main.py, mission_control.py und agentic_flow.py nach /opt/overlord-control"
echo "Starte den Dienst mit: sudo systemctl start overlord-control.service"
