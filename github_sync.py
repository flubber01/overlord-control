import subprocess
import os

def setup_and_sync_github(repo_url, branch="main", commit_msg="Auto-Update v14.0"):
    try:
        if not os.path.exists('.git'):
            print('[Git-Sync] Initialisiere neues lokales Git-Repository...')
            subprocess.run(['git', 'init'], check=True, capture_output=True)

        # Konfiguriere standardmaessige User-Daten falls nicht vorhanden
        subprocess.run(['git', 'config', 'user.name', 'Overlord-Autopilot'], check=True)
        subprocess.run(['git', 'config', 'user.email', 'autopilot@overlord.io'], check=True)

        # Pruefe Remote-Konfiguration
        remotes = subprocess.run(['git', 'remote'], capture_output=True, text=True).stdout
        if 'origin' not in remotes:
            print('[Git-Sync] Fuege Remote origin hinzu: ' + str(repo_url))
            subprocess.run(['git', 'remote', 'add', 'origin', repo_url], check=True)
        else:
            print('[Git-Sync] Remote origin existiert bereits. Aktualisiere URL...')
            subprocess.run(['git', 'remote', 'set-url', 'origin', repo_url], check=True)

        # Stage & Commit
        subprocess.run(['git', 'add', '.'], check=True)
        commit_res = subprocess.run(['git', 'commit', '-m', commit_msg], capture_output=True, text=True)
        msg = commit_res.stdout.strip() if commit_res.stdout else 'Keine neuen Aenderungen'
        print('[Git-Sync] Commit-Status: ' + str(msg))

        # Explizites Umbenennen des lokalen Branches zu 'main'
        print('[Git-Sync] Setze lokalen Branch-Namen auf ' + str(branch) + '...')
        subprocess.run(['git', 'branch', '-M', branch], check=True)

        # Push zu Remote
        print('[Git-Sync] Pushe Code an ' + str(branch) + '...')
        push_res = subprocess.run(['git', 'push', '-u', 'origin', branch, '--force'], capture_output=True, text=True)
        if push_res.returncode == 0:
            return '[SUCCESS] Synchronisiert mit ' + str(repo_url) + ' (Branch: ' + str(branch) + ')'
        else:
            return '[ERROR] Push failed: ' + str(push_res.stderr)
    except Exception as e:
        return '[EXCEPTION] Fehler: ' + str(e)
