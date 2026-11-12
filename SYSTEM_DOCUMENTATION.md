# 🛰️ OVERLORD CLUSTER v14.0 - SYSTEM-DOKUMENTATION

## 📋 Systemarchitektur & Kernkomponenten

Das Overlord Tactical Control Center (v14.0) ist ein verteiltes, hochredundantes Multi-Agenten-Ökosystem zur automatisierten Diagnose, Überwachung, Low-Level C-Kompilierung und synchronisierten Bereitstellung auf virtuellen privaten Servern (VPS).

### 1. Kernmodule des Workspaces

*   **`mission_control.py`**:
    *   **Memory 2.0 (`Memory20`)**: Persistente, versionierte Speicherung (Short-Term & Long-Term) von Agentenprofilen, MCP-Konnektoren und Systemzuständen in `agent_memory_v2.json`.
    *   **ClusterMetrics**: Liefert Echtzeit-Telemetrie-Streams der CPU-, RAM- und Speicherauslastung des aktiven Clusters.
    *   **KanbanSystem**: Verwaltet den workflow-basierten Status von System-Subtasks.
    *   **Ctypes Compiler**: Ermöglicht die In-Memory Kompilierung von nativem C-Code direkt zu gemeinsam genutzten Bibliotheken (`.so`) inklusive integriertem Binär-Hex-Dump-Inspektor.
    *   **Sandboxed Executor**: Führt isolierten Python-Code mit dynamischer, automatischer Auflösung und Installation fehlender pip-Pakete aus.
    *   **Web Crawler / Extractor**: Realisiert asynchrone DuckDuckGo-Suchen für autonomes Informations-Retrieval.

*   **`agentic_flow.py`**:
    *   Implementiert das multi-agentische Orchestrator-System bestehend aus spezialisierten Agenten-Instanzen:
        1.  **Aegis-01** (Orchestrator & Analyst)
        2.  **Neo-Core** (Bypass & Low-Level Assembly Coder)
        3.  **X-Intelligence** (Autonomer High-Intelligence Strategie- & Logik-Generator)
        4.  **Sentry-X** (Validierungs- & Deployment-Auditor)

*   **`github_sync.py`**:
    *   Automatisiert die Git-Initialisierung, das Staging aller Workspace-Dateien, Commits und erzwingt Push-Operationen direkt an ein Remote-Repository zur nahtlosen VPS-Verteilung.

*   **`drive_auto_backup.py`**:
    *   Bietet redundante One-Click-Backups in die Google Drive Cloud mit automatischen Zeitstempel-Sicherungen.

---

## ⚙️ VPS Deployment & Autostart-Konfiguration

Das System stellt dedizierte Skripte bereit, um die Software nahtlos auf Debian/Ubuntu-VPS zu deployen und als ausfallsicheren Hintergrunddienst einzurichten.

### Bereitstellungs-Anleitung (Ubuntu 20.04+ / Debian 11+)

1.  **Repository auf den VPS klonen**:
    ```bash
    git clone <Ihre_Repository_URL> /opt/overlord-control
    cd /opt/overlord-control
    ```

2.  **VPS-Umgebung initialisieren**:
    Führen Sie das generierte Installationsskript aus:
    ```bash
    sudo bash install_vps.sh
    ```
    *Dieses Skript installiert alle System-Abhängigkeiten (Python3-venv, GCC, Git, Make), erstellt eine virtuelle Umgebung und installiert die Python-Packages.*

3.  **Hintergrunddienst konfigurieren (Systemd)**:
    Aktivieren Sie das automatische Starten bei System-Bootup:
    ```bash
    sudo bash vps_systemd_setup.sh
    ```
    Das Skript generiert die Unit `/etc/systemd/system/overlord-control.service`:
    *   **Automatischer Neustart**: Aktiviert bei Abstürzen nach 5 Sekunden Verzögerung.
    *   **Start-Befehl**: `/opt/overlord-control/venv/bin/python main.py`

4.  **Dienst-Steuerung**:
    ```bash
    # Dienst manuell starten
    sudo systemctl start overlord-control
    
    # Status des Control Centers überwachen
    sudo systemctl status overlord-control
    
    # Echtzeit-Logs auslesen
    journalctl -u overlord-control -f
    ```

---

## 🔄 Synchronisations- & Git-Diagnostik
Die Synchronisation wird über die Verschmelzung des Gradio Web-Terminals und des Git-Gunslinger-Subsystems realisiert. Alle Modifikationen im Workspace werden direkt erfasst und mit dem Master-Zweig synchronisiert.
