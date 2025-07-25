import getpass

real_pass = "JaysusSecret42"  # You can store this hashed or get from TOTP gen

otp = getpass.getpass("Enter one-time password to unlock vault: ")

if otp == real_pass:
    print("✅ OTP Verified. Access granted.")
else:
    print("❌ Invalid OTP. Access denied.")
    exit(1)
