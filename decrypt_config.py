import os
import getpass
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

# Load encrypted config
with open("config.json.enc", "rb") as f:
    blob = f.read()

nonce = blob[:12]
ciphertext = blob[12:]

# Load salt
with open("salt.bin", "rb") as f:
    salt = f.read()

# Get passphrase
password = getpass.getpass("Enter passphrase: ").encode()

# Derive key
kdf = Scrypt(salt=salt, length=32, n=2**14, r=8, p=1)
key = kdf.derive(password)

# Decrypt
aesgcm = AESGCM(key)
try:
    plaintext = aesgcm.decrypt(nonce, ciphertext, None)
    with open("config.json", "wb") as f:
        f.write(plaintext)
    print("✅ config.json restored.")
except Exception as e:
    print("❌ Decryption failed:", e)
