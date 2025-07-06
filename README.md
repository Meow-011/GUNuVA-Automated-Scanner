
# 🇬🇧 English • 🇹🇭 ภาษาไทย

---

## ⚠️ Warning

> This project was created **for educational and experimental purposes** in cybersecurity within a **controlled lab environment ONLY**.  
> Do **not** deploy in public, distribute, or use for any illegal activities.  
> The developer assumes **no liability** and is not responsible for any misuse of this software.

---

## 🇬🇧 GUNuVA - Automated Web Application VA Scanner

**GUNuVA (Gemini Universal Network & Web VA Automator)** is an advanced Bash script designed for automated web application vulnerability assessments on **Kali Linux**. It aims to systematically perform reconnaissance, vulnerability scanning, and intelligence gathering.

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

📝 If issues occur, try:
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

Run full scan:
```bash
./gunuva.sh example.com
```

Recon-only mode with output saved:
```bash
./gunuva.sh --mode recon example.com -o
```

---

## 🇹🇭 GUNuVA - สคริปต์ประเมินช่องโหว่เว็บแอปอัตโนมัติ

**GUNuVA (Gemini Universal Network & Web VA Automator)** คือสคริปต์ Bash ที่ออกแบบมาเพื่อทำการประเมินช่องโหว่ของเว็บแอปพลิเคชันแบบอัตโนมัติ ทำงานบน Kali Linux โดยมีเป้าหมายเพื่อรวบรวมข้อมูล, วิเคราะห์, และสแกนช่องโหว่อย่างมีระบบ

### 🎯 วัตถุประสงค์และฟีเจอร์หลัก

- ออกแบบเป็นโมดูล – ง่ายต่อการอ่าน แก้ไข และต่อยอด
- โหมดสแกนที่ยืดหยุ่น – รองรับ full, recon, และ fast
- ผลลัพธ์แบบเลือกได้ – แสดงผลแบบเรียลไทม์ หรือบันทึกลงโฟลเดอร์ (ใช้ `-o`)
- ประมวลผลแบบขนาน – ใช้ GNU Parallel เพื่อเพิ่มความเร็ว
- โมดูลวิเคราะห์ขั้นสูง:
  - วิเคราะห์ JavaScript (.js) ด้วย LinkFinder
  - ตรวจสอบ .git และค้นหา secret ด้วย Gitleaks

---

### ⚙️ กระบวนการทำงาน

| เฟส | ชื่อเฟส              | รายละเอียด                                                                   | เครื่องมือหลัก                              |
|-----|-----------------------|--------------------------------------------------------------------------------|----------------------------------------------|
| 1   | การรวบรวมข้อมูล (Recon) | รวบรวมข้อมูลเบื้องต้นของเป้าหมาย                                            | `subfinder`, `assetfinder`, `curl`, `nmap`, `wafw00f` |
| 2   | การวิเคราะห์ขั้นสูง     | วิเคราะห์สินทรัพย์ที่พบอย่างละเอียด                                          | `feroxbuster`, `linkfinder.py`, `git`, `gitleaks`     |
| 3   | การสแกนหาช่องโหว่       | ตรวจหาช่องโหว่ที่รู้จักในโฮสต์ที่ออนไลน์                                     | `nuclei`, `nikto`, `testssl.sh`                      |
| 4   | การตรวจสอบเฉพาะด้าน     | ตรวจสอบเทคโนโลยีเฉพาะ เช่น CMS                                              | `wpscan`                                     |

---

### 🛠️ การติดตั้ง

**ติดตั้งเครื่องมือพื้นฐาน (บน Kali Linux):**
```bash
sudo apt update && sudo apt install -y golang-go git parallel curl nmap nikto wpscan testssl.sh feroxbuster python3-pip
```

**ตั้งค่าสภาพแวดล้อม Go:**
```bash
echo 'export GOPATH=$HOME/go' >> ~/.profile
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.profile
source ~/.profile
```

**ติดตั้งเครื่องมือจาก Go:**
```bash
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/tomnomnom/assetfinder@latest
go install -v github.com/gitleaks/gitleaks/v8@latest
```

💡 หากติดปัญหา ลองใช้:
```bash
go clean -modcache
```

**ติดตั้งเครื่องมือจาก Python:**
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

**เปิดสิทธิ์ให้สคริปต์ทำงาน:**
```bash
chmod +x gunuva.sh
```

**สแกนแบบเต็มและแสดงผลที่หน้าจอ:**
```bash
./gunuva.sh example.com
```

**โหมดรวบรวมข้อมูลและบันทึกผลลัพธ์ลงไฟล์:**
```bash
./gunuva.sh --mode recon example.com -o
```

---

## 🧾 License / สัญญาอนุญาต

This project is licensed under the **MIT License**.  
โปรเจกต์นี้อยู่ภายใต้สัญญาอนุญาต **MIT**
