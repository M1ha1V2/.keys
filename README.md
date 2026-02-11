# 🔑 SSH Key Bootstrap Script

This repository provides a simple and safe way to **install an SSH public key** on a Linux system directly from GitHub.

It is designed for:
- Server bootstrapping
- Fresh VPS setups
- Automation (cloud-init, CI, provisioning)
- Manual use with safety checks

---

## ✨ Features

- 📥 Downloads an SSH public key from GitHub
- 👤 Asks which user to install the key for  
  - Press **Enter** to default to `root`
- 📁 Creates `~/.ssh` and `authorized_keys` if missing
- 🔁 Prevents duplicate keys
- 🔒 Fixes permissions and ownership (SSH-safe)
- 🧠 Works on all common Linux distributions

---

## 🚀 Quick Start (One Command)

Run the script **directly from GitHub**:

```bash
curl -fsSL https://raw.githubusercontent.com/NaysKutzu/.keys/refs/heads/main/setup.bash | sudo bash
```

