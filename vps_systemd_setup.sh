#!/bin/bash
# Overlord Control Systemd Setup (Auto-Start Engine)
# Dieses Skript konfiguriert den automatischen Systemstart des Control Centers auf Ihrem VPS.

SERVICE_NAME="overlord-control"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
APP_DIR="/opt/overlord-control"

echo "=== 🛰️ STARTING AUTOMATIC SYSTEMD SERVICE SETUP ==="

# Sicherstellen, dass das Verzeichnis existiert
if [ ! -d "$APP_DIR" ]; then
    echo "⚠️ Verzeichnis $APP_DIR existiert nicht. Erstelle Verzeichnis..."
    sudo mkdir -p "$APP_DIR"
fi

echo "[1/3] Generiere Systemd Service-Datei unter ${SERVICE_FILE}..."
sudo bash -c "cat <<EOF > ${SERVICE_FILE}
[Unit]
Description=Overlord Tactical Control Center Service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=${APP_DIR}
ExecStart=${APP_DIR}/venv/bin/python main.py
Restart=always
RestartSec=5
Environment=PYTHONUNBUFFERED=1

[Install]
WantedBy=multi-user.target
EOF"

echo "[2/3] Lade Systemd Daemon neu und aktiviere Autostart..."
sudo systemctl daemon-reload
sudo systemctl enable ${SERVICE_NAME}.service

echo "[3/3] Systemd Status-Check vorbereitet."
echo "=== 🟢 AUTOMATISCHER SYSTEMSTART ERFOLGREICH KONFIGURIERT ==="
echo "Sobald alle Dateien in ${APP_DIR} liegen, starten Sie den Dienst mit:"
echo "  sudo systemctl start ${SERVICE_NAME}.service"
echo "Überprüfen Sie den Status mit:"
echo "  sudo systemctl status ${SERVICE_NAME}.service"
