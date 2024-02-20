# Create a backup of the database file.
import os
import sqlite3

userDir = os.path.expanduser('~')
DB_PATH = userDir + '/BirdNET-Pi/scripts/birds.db'
BACKUP_DB_PATH = userDir + '/Documents/BirdData/birds.db'

def progress(status, remaining, total):
    print(f'Copied {total-remaining} of {total} pages...')

def backup_db():
    src = sqlite3.connect(DB_PATH)
    dst = sqlite3.connect(BACKUP_DB_PATH)
    with dst:
        src.backup(dst, pages=1, progress=progress)
    dst.close()
    src.close()

backup_db()
