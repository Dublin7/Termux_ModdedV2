import os
import subprocess
import getpass
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
import sys

CONFIG_FILE = "config.json"
ENC_FILE = "config.json.enc"
SALT_FILE = "salt.bin"

def tts(msg):
    """Termux TTS voice alert, fallback to print."""
    try:
        subprocess.run(["termux-tts-speak", msg], check=True)
    except Exception:
        print(msg)

def decrypt_config():
    if not os.path.exists(ENC_FILE) or not os.path.exists(SALT_FILE):
        tts("Encrypted config or salt missing.")
        return False

    password = getpass.getpass("🔐 Enter decryption passphrase: ").encode()

    with open(SALT_FILE, "rb") as f:
        salt = f.read()

    with open(ENC_FILE, "rb") as f:
        blob = f.read()
    nonce = blob[:12]
    ciphertext = blob[12:]

    kdf = Scrypt(salt=salt, length=32, n=2**14, r=8, p=1)
    try:
        key = kdf.derive(password)
    except Exception:
        tts("Passphrase derivation failed.")
        return False

    aesgcm = AESGCM(key)
    try:
        plaintext = aesgcm.decrypt(nonce, ciphertext, None)
        with open(CONFIG_FILE, "wb") as f:
            f.write(plaintext)
        tts("Vault unlocked.")
        return True
    except Exception as e:
        tts(f"Decryption failed: {e}")
        return False

def encrypt_config():
    if not os.path.exists(CONFIG_FILE) or not os.path.exists(SALT_FILE):
        tts("Missing config or salt for encryption.")
        return False

    password = getpass.getpass("🔐 Enter encryption passphrase: ").encode()

    with open(SALT_FILE, "rb") as f:
        salt = f.read()

    kdf = Scrypt(salt=salt, length=32, n=2**14, r=8, p=1)
    try:
        key = kdf.derive(password)
    except Exception:
        tts("Passphrase derivation failed.")
        return False

    aesgcm = AESGCM(key)
    with open(CONFIG_FILE, "rb") as f:
        data = f.read()
    nonce = os.urandom(12)
    encrypted = aesgcm.encrypt(nonce, data, None)

    with open(ENC_FILE, "wb") as f:
        f.write(nonce + encrypted)

    os.remove(CONFIG_FILE)
    tts("Vault locked and config wiped.")
    return True

def push_to_github():
    try:
        subprocess.run(["git", "add", "."], check=True)
        subprocess.run(["git", "commit", "-m", "📦 Auto-push memolog"], check=True)
        subprocess.run(["git", "push"], check=True)
        tts("Push complete. All safe.")
    except subprocess.CalledProcessError as e:
        tts(f"Git error: {e}")

def main():
    while True:
        print("\n=== DevsVault GitHub Sync ===")
        print("1) List Repos (gh CLI)")
        print("2) Push memolog.txt to GitHub")
        print("3) Exit")
        choice = input("Choose: ").strip()

        if choice == "1":
            subprocess.run(["gh", "repo", "list"])
        elif choice == "2":
            if not os.path.exists(CONFIG_FILE):
                if not decrypt_config():
                    continue
            push_to_github()
            encrypt_config()
        elif choice == "3":
            tts("Exiting vault.")
            sys.exit(0)
        else:
            print("Invalid option.")

if __name__ == "__main__":
    main()
