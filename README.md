# 🔍 Expert Recon Automation Pipeline

> World-class bug bounty reconnaissance script for comprehensive subdomain enumeration, URL discovery, and vulnerability scanning.

[![GitHub](https://img.shields.io/badge/GitHub-MhdAsfan-blue)](https://github.com/MhdAsfan)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

---

## 📋 Overview

Production-ready, fully automated reconnaissance pipeline for bug bounty hunters and security researchers.

**Features:**
- ✅ Passive subdomain enumeration
- ✅ DNS resolution and HTTP probing
- ✅ URL crawling and discovery
- ✅ JavaScript analysis and endpoint extraction
- ✅ Parameter discovery
- ✅ Vulnerability scanning (Nuclei)
- ✅ Cloud asset discovery

---

## 🛠️ Installation

### Prerequisites

- Linux/macOS (Windows WSL2 supported)
- Go 1.19+ installed
- Python 3.8+
- Git

### Install Required Tools
Install Go tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
go install -v github.com/projectdiscovery/katana/cmd/katana@latest
go install -v github.com/tomnomnom/waybackurls@latest
go install -v github.com/lc/gau/v2/cmd/gau@latest
go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest

Install Amass
go install -v github.com/owasp-amass/amass/v4/...@master


### Clone Repository
git clone https://github.com/MhdAsfan/recon.git
cd recon
chmod +x recon.sh



---

## 📖 Usage

### Basic Usage
./recon.sh <domain>



### Example
./recon.sh uber.com


### Output Structure
recon_uber.com_20251121_100000/
├── subdomains/
│ ├── subfinder.txt
│ ├── amass.txt
│ ├── all_subdomains.txt
│ └── resolved.txt
├── urls/
│ ├── httpx.json
│ ├── live_urls.txt
│ ├── wayback.txt
│ └── all_urls.txt
├── endpoints/
├── params/
├── secrets/
└── vulnerabilities/
└── nuclei.txt


---

## 🎯 Workflow Phases

| Phase | Description                    | Tools Used                 |
|-------|-------------------------------|---------------------------|
| **1** | Passive Subdomain Enumeration | Subfinder, Amass, crt.sh  |
| **2** | DNS Resolution                | dnsx                      |
| **3** | HTTP Probing                  | httpx                     |
| **4** | URL Discovery                 | Wayback, GAU, Katana      |
| **5** | Vulnerability Scanning        | Nuclei                    |

---

## 🔥 Pro Tips

- Run on a **VPS** for faster results
- Review results manually for best findings
- Combine with manual testing
- Use for authorized testing only

---

## ⚠️ Disclaimer

This tool is for **authorized security testing only**. Always obtain proper permission before testing any system.

---

## 📧 Contact

**Author**: MhdAsfan  
**GitHub**: [@MhdAsfan](https://github.com/MhdAsfan)

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🌟 Star This Repo!

If you find this useful, please ⭐ star the repository!






