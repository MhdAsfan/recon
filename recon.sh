#!/bin/bash

# ========================================
# EXPERT RECON AUTOMATION PIPELINE v2.1
# Author: MhdAsfan
# Description: Production-ready bug bounty recon
# Last Updated: November 2025
# ========================================

set -euo pipefail

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

banner() {
    echo -e "${BLUE}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "   EXPERT RECON AUTOMATION PIPELINE v2.1"
    echo "   Bug Bounty Reconnaissance Suite"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${NC}"
}

check_dependencies() {
    local missing_tools=()
    local tools=("subfinder" "httpx" "nuclei" "katana" "waybackurls" "jq" "dnsx" "gau" "amass")
    
    echo -e "${YELLOW}[*] Checking dependencies...${NC}"
    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done
    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${RED}[!] Missing tools: ${missing_tools[*]}${NC}"
        echo -e "${YELLOW}[*] Install them and try again.${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] All dependencies found!${NC}"
}

if [ $# -eq 0 ]; then
    echo -e "${RED}[!] Usage: $0 <domain>${NC}"
    echo -e "${YELLOW}[*] Example: $0 uber.com${NC}"
    exit 1
fi

DOMAIN=$1
OUTPUT_DIR="recon_${DOMAIN}_$(date +%Y%m%d_%H%M%S)"

mkdir -p "$OUTPUT_DIR"/{subdomains,urls,endpoints,params,secrets,vulnerabilities,screenshots}

banner
check_dependencies

echo -e "${GREEN}[+] Target: $DOMAIN${NC}"
echo -e "${GREEN}[+] Output: $OUTPUT_DIR${NC}"
echo ""

START_TIME=$(date +%s)

# 1. Passive Subdomain Enumeration
echo -e "${BLUE}[*] Phase 1: Passive Subdomain Enumeration${NC}"
subfinder -d "$DOMAIN" -all -silent -o "$OUTPUT_DIR/subdomains/subfinder.txt" || true
timeout 300 amass enum -passive -d "$DOMAIN" -o "$OUTPUT_DIR/subdomains/amass.txt" || true
curl -s "https://crt.sh/?q=%25.$DOMAIN&output=json" | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > "$OUTPUT_DIR/subdomains/crtsh.txt" || true
cat "$OUTPUT_DIR/subdomains/"*.txt 2>/dev/null | sort -u > "$OUTPUT_DIR/subdomains/all_subdomains.txt"
TOTAL_SUBS=$(wc -l < "$OUTPUT_DIR/subdomains/all_subdomains.txt" 2>/dev/null || echo "0")
echo -e "${GREEN}[+] Total Subdomains: $TOTAL_SUBS${NC}"

# 2. DNS Resolution
echo -e "${BLUE}[*] Phase 2: Resolving Subdomains${NC}"
cat "$OUTPUT_DIR/subdomains/all_subdomains.txt" | dnsx -silent -o "$OUTPUT_DIR/subdomains/resolved.txt" || true
LIVE_SUBS=$(wc -l < "$OUTPUT_DIR/subdomains/resolved.txt" 2>/dev/null || echo "0")
echo -e "${GREEN}[+] Live Subdomains: $LIVE_SUBS${NC}"

# 3. HTTP Probing
echo -e "${BLUE}[*] Phase 3: HTTP Probing${NC}"
cat "$OUTPUT_DIR/subdomains/resolved.txt" | httpx -silent -threads 50 -ports 80,443,8080,8443 -json -o "$OUTPUT_DIR/urls/httpx.json" || true
cat "$OUTPUT_DIR/urls/httpx.json" 2>/dev/null | jq -r '.url' > "$OUTPUT_DIR/urls/live_urls.txt" || true
LIVE_URLS=$(wc -l < "$OUTPUT_DIR/urls/live_urls.txt" 2>/dev/null || echo "0")
echo -e "${GREEN}[+] Live URLs: $LIVE_URLS${NC}"

# 4. URL Discovery
echo -e "${BLUE}[*] Phase 4: URL Discovery${NC}"
echo "$DOMAIN" | waybackurls > "$OUTPUT_DIR/urls/wayback.txt" || true
echo "$DOMAIN" | gau --threads 5 > "$OUTPUT_DIR/urls/gau.txt" || true
if [ -s "$OUTPUT_DIR/urls/live_urls.txt" ]; then
    katana -list "$OUTPUT_DIR/urls/live_urls.txt" -d 2 -jc -silent -o "$OUTPUT_DIR/urls/katana.txt" || true
fi
cat "$OUTPUT_DIR/urls/"*.txt 2>/dev/null | grep -E "$DOMAIN" | sort -u > "$OUTPUT_DIR/urls/all_urls.txt" || true
TOTAL_URLS=$(wc -l < "$OUTPUT_DIR/urls/all_urls.txt" 2>/dev/null || echo "0")
echo -e "${GREEN}[+] Total URLs: $TOTAL_URLS${NC}"

# 5. Javascript Analysis
echo -e "${BLUE}[*] Phase 5: JavaScript Analysis${NC}"
grep -iE '\.js($|\?)' "$OUTPUT_DIR/urls/all_urls.txt" > "$OUTPUT_DIR/endpoints/js_files.txt" 2>/dev/null || true

# Secret scanning
echo -e "${YELLOW}[*] Scanning for secrets in JS...${NC}"
grep -rEi 'api[_-]?key|apikey|api[_-]?secret|access[_-]?token|auth[_-]?token|secret[_-]?key|private[_-]?key|client[_-]?secret' "$OUTPUT_DIR/urls/all_urls.txt" > "$OUTPUT_DIR/secrets/potential_secrets.txt" 2>/dev/null || true

# 6. Parameter Discovery
echo -e "${BLUE}[*] Phase 6: Parameter Discovery${NC}"
if command -v gf &> /dev/null; then
    cat "$OUTPUT_DIR/urls/all_urls.txt" 2>/dev/null | gf params > "$OUTPUT_DIR/params/gf_params.txt" 2>/dev/null || true
fi

# 7. Vulnerability Scanning
echo -e "${BLUE}[*] Phase 7: Vulnerability Scanning${NC}"
if [ -s "$OUTPUT_DIR/urls/live_urls.txt" ]; then
    nuclei -list "$OUTPUT_DIR/urls/live_urls.txt" -severity critical,high,medium -silent -o "$OUTPUT_DIR/vulnerabilities/nuclei.txt" || true
fi

# 8. S3 Bucket Discovery
echo -e "${BLUE}[*] Phase 8: Cloud Asset Discovery${NC}"
grep -rEi 's3\\.amazonaws\\.com|s3-[a-z0-9-]+\\.amazonaws\\.com' "$OUTPUT_DIR/urls/" > "$OUTPUT_DIR/secrets/s3_buckets.txt" 2>/dev/null || true

END_TIME=$(date +%s)
RUNTIME=$((END_TIME - START_TIME))

# Final report
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}   RECON COMPLETE!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}[+] Target:${NC} $DOMAIN"
echo -e "${BLUE}[+] Total Subdomains:${NC} $TOTAL_SUBS"
echo -e "${BLUE}[+] Live Subdomains:${NC} $LIVE_SUBS"
echo -e "${BLUE}[+] Live URLs:${NC} $LIVE_URLS"
echo -e "${BLUE}[+] Total URLs:${NC} $TOTAL_URLS"
echo -e "${BLUE}[+] Runtime:${NC} ${RUNTIME}s"
echo ""
echo -e "${YELLOW}[*] Results saved in: $OUTPUT_DIR${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
