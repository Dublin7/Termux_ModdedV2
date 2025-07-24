import json
import os
import base64
import getpass
from cryptography.hazmat.primitives.kdf.scrypt import Scrypt
from cryptography.hazmat.primitives.ciphers.aead import AESGCM

# Read the raw config
with open("config.json", "rb") as f:
    data = f.read()

# Prompt for passphrase (not echoed)
password = getpass.getpass("Enter passphrase: ").encode()

# Generate random salt
salt = os.urandom(16)
with open("salt.bin", "wb") as f:
    f.write(salt)

# Derive encryption key from password
kdf = Scrypt(salt=salt, length=32, n=2**14, r=8, p=1)
key = kdf.derive(password)

# Encrypt the config using AES-GCM
aesgcm = AESGCM(key)
nonce = os.urandom(12)
ciphertext = aesgcm.encrypt(nonce, data, None)

# Store encrypted file
with open("config.json.enc", "wb") as f:
    f.write(nonce + ciphertext)

print("✅ Encrypted as config.json.enc and saved salt.bin")
