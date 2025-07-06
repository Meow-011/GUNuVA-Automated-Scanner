## ⚠️ Warning

> This project was created **for educational and experimental purposes** in cybersecurity within a **controlled lab environment ONLY**.  
> Do **not** deploy in public, distribute, or use for any illegal activities.  
> The developer assumes **no liability** and is not responsible for any misuse of this software.

---

## English Version <a name="english"></a>
## GUNuVA - Automated Web Application VA Scanner

**GUNuVA (Web VA Automator)** is an advanced Bash script designed for automated web application vulnerability assessments on **Kali Linux**. It aims to systematically perform reconnaissance, vulnerability scanning, and intelligence gathering.

### 🎯 Objective & Core Features

- **Modular Design** – Easy to read, modify, and extend.
- **Flexible Scan Modes** – Supports `full`, `recon`, and `fast` modes.
- **Optional Output** – Choose between real-time terminal output or structured directory logging (`-o` flag).
- **Parallel Processing** – Uses `GNU Parallel` for faster host discovery.
- **Advanced Intelligence Modules**:
  - **JavaScript Analysis** – Finds and analyzes `.js` files using `LinkFinder`.
  - **Secret Scanning** – Detects `.git` repositories and scans with `Gitleaks`.

---

### ⚙️ Workflow & Architecture

| Phase | Name                  | Description                                                                 | Key Tools                                 |
|-------|-----------------------|-----------------------------------------------------------------------------|-------------------------------------------|
| 1     | Reconnaissance        | Gathers initial information to expand the attack surface                    | `subfinder`, `assetfinder`, `curl`, `nmap`, `wafw00f` |
| 2     | Advanced Intelligence | Deep analysis of discovered assets for sensitive data                       | `feroxbuster`, `linkfinder.py`, `git`, `gitleaks`     |
| 3     | Vulnerability Scanning| Scans live hosts for known vulnerabilities                                  | `nuclei`, `nikto`, `testssl.sh`                     |
| 4     | Specific Checks       | Targets specific tech like CMS                                              | `wpscan`                                  |

---

### 🛠️ Installation

**System Dependencies (Kali Linux):**
```bash
sudo apt update && sudo apt install -y golang-go git parallel curl nmap nikto wpscan testssl.sh feroxbuster python3-pip
```

**Set up Go Environment:**
```bash
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.profile
source ~/.profile
```

**Install Go-based Tools:**
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/gitleaks/gitleaks/v8@latest
```

> 💡 If you encounter issues, try:
```bash
go clean -modcache
```

**Install Python-based Tools (LinkFinder):**
```bash
git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
sudo pip3 install -r requirements.txt --break-system-packages
sudo ln -s "$(pwd)/linkfinder.py" /usr/local/bin/linkfinder.py
sudo ln -s "$(pwd)/linkfinder.py" /usr/local/bin/linkfinder
cd ~
```

---

### 🚀 Usage

Make the script executable:
```bash
chmod +x gunuva.sh
```

**Command Format:**
```bash
./gunuva.sh [TARGET] [OPTIONS]
```

**Options:**
- `--mode [recon|fast|full]`: Scan mode (default: `full`)
- `-o` or `--output`: Save output to directory

#### 🔍 Scan Modes Explained

- **`full` (default):** Full scan across all phases  
  ```bash
  ./gunuva.sh example.com
  ```

- **`recon`:** Reconnaissance only (Phase 1)  
  ```bash
  ./gunuva.sh example.com --mode recon
  ```

- **`fast`:** Quick recon + curated Nuclei scan  
  ```bash
  ./gunuva.sh example.com --mode fast
  ```

**Saving Output:**
```bash
./gunuva.sh example.com --mode full -o
```
> Creates directory: `VA_Results_example.com_[TIMESTAMP]`

---
---
---

## ภาษาไทย <a name="ภาษาไทย"></a>
## GUNuVA - สคริปต์ประเมินช่องโหว่เว็บแอปพลิเคชันอัตโนมัติ

**GUNuVA (Web VA Automator)** คือ Bash Script สำหรับประเมินช่องโหว่เว็บแอปพลิเคชันบน Kali Linux โดยทำงานอัตโนมัติอย่างเป็นระบบ ทั้งการ Recon, สแกน, และวิเคราะห์ข้อมูลเชิงลึก

### 🎯 วัตถุประสงค์และฟีเจอร์หลัก

- **โมดูลาร์:** อ่านและพัฒนาได้ง่าย
- **โหมดการสแกน:** `full`, `recon`, `fast`
- **ผลลัพธ์แบบเลือกได้:** Terminal หรือไฟล์ (ใช้ `-o`)
- **ประมวลผลแบบขนาน:** ด้วย GNU Parallel
- **วิเคราะห์เชิงลึก:**
  - วิเคราะห์ `.js` ด้วย LinkFinder
  - ตรวจสอบ `.git` และ secrets ด้วย Gitleaks

---

### ⚙️ กระบวนการทำงาน

| เฟส | ชื่อเฟส              | คำอธิบาย                                                  | เครื่องมือหลัก |
|-----|----------------------|-------------------------------------------------------------|----------------|
| 1   | Reconnaissance       | รวบรวมข้อมูลเบื้องต้นของเป้าหมาย                         | subfinder, assetfinder, curl, nmap, wafw00f |
| 2   | Advanced Intelligence| วิเคราะห์เชิงลึกข้อมูลที่พบ                                | feroxbuster, linkfinder.py, git, gitleaks |
| 3   | Vulnerability Scan   | สแกนโฮสต์ที่เปิดใช้งานและหาช่องโหว่ที่รู้จัก              | nuclei, nikto, testssl.sh |
| 4   | Specific Checks      | ตรวจสอบเทคโนโลยีเฉพาะ เช่น CMS                            | wpscan |

---

### 🛠️ การติดตั้ง (Kali Linux)

**ติดตั้ง Dependencies:**
```bash
sudo apt update && sudo apt install -y golang-go git parallel curl nmap nikto wpscan testssl.sh feroxbuster python3-pip
```

**ตั้งค่า Go:**
```bash
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.profile
source ~/.profile
```

**ติดตั้ง Go-based Tools:**
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/gitleaks/gitleaks/v8@latest
```

> 💡 หากมีปัญหา:
```bash
go clean -modcache
```

**ติดตั้ง Python-based Tools:**
```bash
git clone https://github.com/GerbenJavado/LinkFinder.git
cd LinkFinder
sudo pip3 install -r requirements.txt --break-system-packages
sudo ln -s "$(pwd)/linkfinder.py" /usr/local/bin/linkfinder.py
sudo ln -s "$(pwd)/linkfinder.py" /usr/local/bin/linkfinder
cd ~
```

---

### 🚀 วิธีใช้งาน

**ให้สิทธิ์รันสคริปต์:**
```bash
chmod +x gunuva.sh
```

**รูปแบบคำสั่ง:**
```bash
./gunuva.sh [เป้าหมาย] [ออปชัน]
```

**ออปชัน:**
- `--mode [recon|fast|full]` (ค่าเริ่มต้น: full)
- `-o` หรือ `--output`: บันทึกผลลัพธ์ลงโฟลเดอร์

**ตัวอย่าง:**

- **สแกนเต็ม:**
  ```bash
  ./gunuva.sh example.com
  ```

- **รวบรวมข้อมูล:**
  ```bash
  ./gunuva.sh example.com --mode recon
  ```

- **สแกนแบบรวดเร็ว:**
  ```bash
  ./gunuva.sh example.com --mode fast
  ```

- **บันทึกผลลัพธ์:**
  ```bash
  ./gunuva.sh example.com --mode full -o
  ```

> 📂 โฟลเดอร์ผลลัพธ์: `VA_Results_example.com_[เวลา]`

---

## 🧾 License

This project is licensed under the **MIT License**.  
โปรเจกต์นี้อยู่ภายใต้สัญญาอนุญาตแบบ **MIT**
