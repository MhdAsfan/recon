# 🚀 RECON SCRIPT USAGE GUIDE

**Expert Bug Bounty Reconnaissance Pipeline - Complete Setup & Execution Guide**

---

## 📋 PREREQUISITES

### ✅ Step 1: Verify Tool Installation

Before running the script, check if all required tools are installed:

```bash
# Check if tools are installed
command -v subfinder || echo "❌ subfinder not found"
command -v httpx || echo "❌ httpx not found"
command -v nuclei || echo "❌ nuclei not found"
command -v katana || echo "❌ katana not found"
command -v waybackurls || echo "❌ waybackurls not found"
command -v dnsx || echo "❌ dnsx not found"
command -v gau || echo "❌ gau not found"
command -v amass || echo "❌ amass not found"
command -v jq || echo "❌ jq not found"
```

**If any tools are missing**, install them using the commands in the main README.

---

## 🔧 SETUP

### Step 2: Make Script Executable

```bash
chmod +x recon.sh
```

---

## 🎯 RUNNING THE SCRIPT

### Step 3A: For Windows Users (WSL/Git Bash)

```bash
# Open WSL or Git Bash terminal
cd C:/Users/a/GITHUB/recon
bash recon.sh target.com
```

### Step 3B: For Linux/macOS Users

```bash
# Navigate to script directory
cd ~/recon
./recon.sh target.com
```

---

## 💡 USAGE EXAMPLES

### Example 1: Basic Single Target Scan

```bash
./recon.sh uber.com
```

**What Happens:**
1. ✅ Creates folder: `recon_uber.com_20251121_100600/`
2. ✅ Runs passive recon (Subfinder, Amass, crt.sh)
3. ✅ Resolves live subdomains
4. ✅ Probes HTTP services (ports 80, 443, 8080, 8443)
5. ✅ Gathers URLs from Wayback Machine, GAU, Katana crawler
6. ✅ Analyzes JavaScript files for endpoints
7. ✅ Discovers parameters (GF patterns)
8. ✅ Scans for vulnerabilities (Nuclei templates)
9. ✅ Searches for cloud assets (S3 buckets)

**⏱️ Expected Runtime:** 10-30 minutes (depends on target size)

---

### Example 2: Wildcard Scope Targets

```bash
./recon.sh uber.com
./recon.sh api.uber.com
./recon.sh partners.uber.com
```

---

### Example 3: Multiple Targets (Automated Loop)

```bash
for domain in uber.com lyft.com tesla.com; do
    ./recon.sh "$domain"
    echo "✅ Completed: $domain"
done
```

---

## 📊 UNDERSTANDING YOUR RESULTS

### Step 4: Navigate to Results Directory

```bash
cd recon_target.com_*/
```

### Key Files to Review

```bash
# 🔍 Most Important Files:

# 1. Live Subdomains (Start Here!)
cat subdomains/resolved.txt

# 2. Active Web Services
cat urls/live_urls.txt

# 3. Potential API Keys & Secrets (HIGH VALUE!)
cat secrets/potential_secrets.txt

# 4. Security Vulnerabilities Found
cat vulnerabilities/nuclei.txt

# 5. Testable Parameters for Bug Hunting
cat params/gf_params.txt

# 6. All Discovered URLs
cat urls/all_urls.txt

# 7. Cloud Storage Buckets
cat secrets/s3_buckets.txt
```

---

## 📁 OUTPUT DIRECTORY STRUCTURE

```
recon_uber.com_20251121_100600/
│
├── 📂 subdomains/
│   ├── subfinder.txt          # Subfinder results
│   ├── amass.txt              # Amass passive results
│   ├── crtsh.txt              # Certificate transparency
│   ├── all_subdomains.txt     # Combined unique subdomains
│   └── resolved.txt           # ✨ Live/active subdomains
│
├── 📂 urls/
│   ├── httpx.json             # HTTP probe results (JSON)
│   ├── live_urls.txt          # ✨ Active web URLs
│   ├── wayback.txt            # Wayback Machine URLs
│   ├── gau.txt                # GAU discovered URLs
│   ├── katana.txt             # Katana crawler results
│   └── all_urls.txt           # All URLs combined
│
├── 📂 endpoints/
│   └── js_files.txt           # JavaScript file URLs
│
├── 📂 params/
│   └── gf_params.txt          # ✨ Discovered parameters
│
├── 📂 secrets/
│   ├── potential_secrets.txt  # ✨ API keys, tokens found
│   └── s3_buckets.txt         # S3 bucket references
│
└── 📂 vulnerabilities/
    └── nuclei.txt             # ✨ Security issues detected
```

---

## 🎯 QUICK START CHEAT SHEET

```bash
# 1. Check dependencies
command -v subfinder httpx nuclei katana waybackurls

# 2. Make executable
chmod +x recon.sh

# 3. Run scan
./recon.sh target.com

# 4. Check results (after completion)
cd recon_target.com_*/
cat subdomains/resolved.txt
cat secrets/potential_secrets.txt
cat vulnerabilities/nuclei.txt
```

---

## 🔥 PRO TIPS

### 💰 Finding High-Value Bugs

```bash
# Check these files first for quick wins:
1. secrets/potential_secrets.txt  → API key leaks
2. vulnerabilities/nuclei.txt     → Known CVEs
3. params/gf_params.txt           → XSS/SQLi testing points
4. secrets/s3_buckets.txt         → Open buckets
```

### ⚡ Performance Optimization

- **Run on VPS** for 3-5x faster execution
- **Use screen/tmux** for long-running scans:
  ```bash
  screen -S recon
  ./recon.sh target.com
  # Press Ctrl+A then D to detach
  ```

### 🛡️ Staying Safe

- **Always get authorization** before scanning
- **Respect rate limits** and scope boundaries
- **Use VPN/proxy** for sensitive targets
- **Keep logs** of your testing activities

---

## 🐛 TROUBLESHOOTING

### Issue: "Tool not found" errors

**Solution:**
```bash
# Re-run installation commands for missing tools
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest
```

### Issue: Permission denied

**Solution:**
```bash
chmod +x recon.sh
```

### Issue: No results found

**Solution:**
- Check internet connection
- Verify target domain is correct
- Ensure tools have proper API keys configured (Subfinder, Amass)

---

## 📈 WORKFLOW INTEGRATION

### Daily Bug Bounty Routine

```bash
# Morning: Quick recon on new programs
./recon.sh newprogram.com

# Review results during coffee:
grep -i "api.*key" recon_*/secrets/*.txt

# Deep dive on interesting findings:
nuclei -l recon_*/urls/live_urls.txt -t custom-templates/
```

---

## ✅ READY TO HUNT!

**Your recon automation is now ready to discover vulnerabilities like a pro!**

🎯 **Next Steps:**
1. Run your first scan on a authorized target
2. Review the results systematically
3. Manually test interesting findings
4. Report valid vulnerabilities responsibly

**Happy Hunting! 🔍💰**

---

## 📧 SUPPORT

If you encounter issues:
- Check the main README.md
- Review tool documentation
- Open an issue on GitHub

---

*Last Updated: November 21, 2025*  
*Author: MhdAsfan*  
*Repository: https://github.com/MhdAsfan/recon*
