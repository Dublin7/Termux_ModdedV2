from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Protocol.KDF import PBKDF2
import json, os

password = input("Enter a password to encrypt the config: ").encode()
salt = get_random_bytes(16)
key = PBKDF2(password, salt, dkLen=32)

with open("config.json", "rb") as f:
    data = f.read()
    cipher = AES.new(key, AES.MODE_GCM)
    ciphertext, tag = cipher.encrypt_and_digest(data)

with open("config.json.enc", "wb") as f:
    f.write(cipher.nonce + tag + ciphertext)

with open("salt.bin", "wb") as f:
    f.write(salt)

os.remove("config.json")
print("✔️ Encrypted config.json -> config.json.enc")
