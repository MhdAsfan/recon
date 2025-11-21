(
echo # 🔍 Expert Recon Automation Pipeline
echo.
echo ^> World-class bug bounty reconnaissance script for comprehensive subdomain enumeration, URL discovery, and vulnerability scanning.
echo.
echo [![GitHub](https://img.shields.io/badge/GitHub-MhdAsfan-blue)](https://github.com/MhdAsfan)
echo [![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
echo.
echo ---
echo.
echo ## 📋 Overview
echo.
echo Production-ready, fully automated reconnaissance pipeline for bug bounty hunters and security researchers.
echo.
echo **Features:**
echo - ✅ Passive subdomain enumeration
echo - ✅ DNS resolution and HTTP probing
echo - ✅ URL crawling and discovery
echo - ✅ JavaScript analysis and endpoint extraction
echo - ✅ Parameter discovery
echo - ✅ Vulnerability scanning ^(Nuclei^)
echo - ✅ Cloud asset discovery
echo.
echo ---
echo.
echo ## 🛠️ Installation
echo.
echo ### Prerequisites
echo.
echo - Linux/macOS ^(Windows WSL2 supported^)
echo - Go 1.19+ installed
echo - Python 3.8+
echo - Git
echo.
echo ### Install Required Tools
echo.
echo ```
echo # Install Go tools
echo go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
echo go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest
echo go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
echo go install -v github.com/projectdiscovery/katana/cmd/katana@latest
echo go install -v github.com/tomnomnom/waybackurls@latest
echo go install -v github.com/lc/gau/v2/cmd/gau@latest
echo go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
echo.
echo # Install Amass
echo go install -v github.com/owasp-amass/amass/v4/...@master
echo ```
echo.
echo ### Clone Repository
echo.
echo ```
echo git clone https://github.com/MhdAsfan/recon.git
echo cd recon
echo chmod +x recon.sh
echo ```
echo.
echo ---
echo.
echo ## 📖 Usage
echo.
echo ### Basic Usage
echo.
echo ```
echo ./recon.sh ^<domain^>
echo ```
echo.
echo ### Example
echo.
echo ```
echo ./recon.sh uber.com
echo ```
echo.
echo ### Output Structure
echo.
echo ```
echo recon_uber.com_20251121_100000/
echo ├── subdomains/
echo │   ├── subfinder.txt
echo │   ├── amass.txt
echo │   ├── all_subdomains.txt
echo │   └── resolved.txt
echo ├── urls/
echo │   ├── httpx.json
echo │   ├── live_urls.txt
echo │   ├── wayback.txt
echo │   └── all_urls.txt
echo ├── endpoints/
echo ├── params/
echo ├── secrets/
echo └── vulnerabilities/
echo     └── nuclei.txt
echo ```
echo.
echo ---
echo.
echo ## 🎯 Workflow Phases
echo.
echo ^| Phase ^| Description ^| Tools Used ^|
echo ^|-------^|-------------^|------------^|
echo ^| **1** ^| Passive Subdomain Enumeration ^| Subfinder, Amass, crt.sh ^|
echo ^| **2** ^| DNS Resolution ^| dnsx ^|
echo ^| **3** ^| HTTP Probing ^| httpx ^|
echo ^| **4** ^| URL Discovery ^| Wayback, GAU, Katana ^|
echo ^| **5** ^| Vulnerability Scanning ^| Nuclei ^|
echo.
echo ---
echo.
echo ## 🔥 Pro Tips
echo.
echo - Run on a **VPS** for faster results
echo - Review results manually for best findings
echo - Combine with manual testing
echo - Use for authorized testing only
echo.
echo ---
echo.
echo ## ⚠️ Disclaimer
echo.
echo This tool is for **authorized security testing only**. Always obtain proper permission before testing any system.
echo.
echo ---
echo.
echo ## 📧 Contact
echo.
echo **Author**: MhdAsfan  
echo **GitHub**: [@MhdAsfan](https://github.com/MhdAsfan)
echo.
echo ---
echo.
echo ## 📜 License
echo.
echo MIT License - see [LICENSE](LICENSE) file for details.
echo.
echo ---
echo.
echo ## 🌟 Star This Repo!
echo.
echo If you find this useful, please ⭐ star the repository!
) > README.md
"# recon" 
