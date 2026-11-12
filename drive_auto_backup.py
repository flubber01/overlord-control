import os
from google.colab import drive
import shutil
from datetime import datetime

def backup_to_drive():
    try:
        print('[Drive-Backup] Initialisiere Verbindung zu Google Drive...')
        drive.mount('/content/drive', force_remount=True)
        
        backup_dir = '/content/drive/MyDrive/Overlord_Control_Backup'
        os.makedirs(backup_dir, exist_ok=True)
        
        files_to_backup = ['mission_control.py', 'agentic_flow.py', 'install_vps.sh', 'agent_memory_v2.json', 'kanban_state.json']
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        
        for f in files_to_backup:
            if os.path.exists(f):
                shutil.copy(f, os.path.join(backup_dir, f))
                shutil.copy(f, os.path.join(backup_dir, f'{f}.{timestamp}.bak'))
        
        return f'🟢 [Drive-Backup Success] Erfolgreich gesichert in Drive: {backup_dir} ({timestamp})'
    except Exception as e:
        return f'🔴 [Drive-Backup Error] Sicherung fehlgeschlagen: {str(e)}'

if __name__ == "__main__":
    print(backup_to_drive())
