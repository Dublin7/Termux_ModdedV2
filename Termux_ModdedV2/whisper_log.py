import sys
from datetime import datetime

entry = sys.argv[1] if len(sys.argv) > 1 else "Whisper logged."
with open("vault.log", "a") as f:
    f.write(f"#∴MINTR@{datetime.now().strftime('%d-%b %H:%M')} {entry}\n")
