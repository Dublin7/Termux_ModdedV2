from Crypto.Cipher import AES
from Crypto.Protocol.KDF import PBKDF2

password = input("Enter password to decrypt config: ").encode()

with open("salt.bin", "rb") as f:
    salt = f.read()
key = PBKDF2(password, salt, dkLen=32)

with open("config.json.enc", "rb") as f:
    nonce = f.read(16)
    tag = f.read(16)
    ciphertext = f.read()

cipher = AES.new(key, AES.MODE_GCM, nonce=nonce)
data = cipher.decrypt_and_verify(ciphertext, tag)

with open("config.json", "wb") as f:
    f.write(data)

print("🔓 config.json decrypted and restored.")
