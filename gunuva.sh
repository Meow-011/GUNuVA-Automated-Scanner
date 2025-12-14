
#!/bin/bash

# #############################################################################
# GUNuVA - Automated Web Application VA Script
# Version: 4.4 (Robust JS Analysis Argument Passing)
#
# Description:
# This version provides a critical fix to the JS Intelligence module,
# resolving an argument passing issue with linkfinder. It now calls
# linkfinder directly to ensure URLs are processed correctly.
#
# Usage:
# ./web_va_script.sh [TARGET] [OPTIONS]
#
# Options:
#   --mode [recon|fast|full] : Sets the scan mode (default: full).
#   -o, --output             : Enable logging and save results to a directory.
# #############################################################################

# =============================================================================
# CONFIGURATION SECTION
# =============================================================================
WORDLIST_PATH="/usr/share/wordlists/dirb/common.txt"
NUCLEI_TEMPLATES_PATH=""
THREADS=10
PROBE_JOBS=50

# =============================================================================
# SCRIPT VARIABLES (DO NOT EDIT)
# =============================================================================
TESTSSL_CMD=""
LIVE_HOSTS=""
LOGGING_ENABLED=false
RESULTS_DIR=""
RECON_DIR=""
ADVANCED_DIR=""
SCAN_DIR=""
SPECIFIC_DIR=""

# =============================================================================
# COLORS AND STYLES (DO NOT EDIT)
# =============================================================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# =============================================================================
# SCRIPT FUNCTIONS
# =============================================================================

function print_banner() {
    echo -e "${CYAN}"
    echo "   ____ _   _ _   _   _   _    _   "
    echo "  / ___| | | | \ | | | | | |  / \  "
    echo " | |  _| | | |  \| | | | | | / _ \ "
    echo " | |_| | |_| | |\  | | |_| |/ ___ \ "
    echo "  \____|\___/|_| \_|  \___//_/   \_\ "
    echo "         VA Automation v4.4 (Robust)"
    echo -e "${NC}"
}

function usage() {
    echo -e "\n${YELLOW}Usage:${NC} $0 [TARGET] [OPTIONS]"
    echo -e "\n${YELLOW}Options:${NC}"
    echo "  --mode [recon|fast|full]   Sets the scan mode (default: full)."
    echo "  -o, --output               Enable logging and save results to a directory."
    exit 1
}

function check_dependencies() {
    echo -e "\n${BLUE}[*] ⚙️  Checking for required tools...${NC}"
    local missing_tools=0
    local tools=("subfinder" "assetfinder" "curl" "nmap" "nuclei" "feroxbuster" "wafw00f" "wpscan" "nikto" "parallel" "gitleaks" "linkfinder.py")

    for tool in "${tools[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo -e "${RED}[-] ❌ Tool not found: $tool. Please install it.${NC}"
            missing_tools=$((missing_tools + 1))
        fi
    done

    TESTSSL_CMD=$(command -v "testssl.sh")
    if [ -z "$TESTSSL_CMD" ]; then
        TESTSSL_CMD=$(find / -type f -name "testssl.sh" 2>/dev/null | head -n 1)
        if [ -n "$TESTSSL_CMD" ]; then
            echo -e "${GREEN}[+] ✅ Found testssl.sh at: $TESTSSL_CMD${NC}"
        else
            echo -e "${RED}[-] ❌ Tool not found: testssl.sh${NC}"
            missing_tools=$((missing_tools + 1))
        fi
    fi

    if [ "$missing_tools" -gt 0 ]; then
        echo -e "${RED}[!] 🛑 Found $missing_tools missing tool(s). Aborting.${NC}"
        exit 1
    fi
    echo -e "${GREEN}[+] ✅ All required tools are available.${NC}"
}

# Helper function to handle output
run_and_log() {
    local command_to_run="$1"
    local log_file="$2"
    
    if [ "$LOGGING_ENABLED" = true ]; then
        eval "$command_to_run" 2>&1 | tee -a "$log_file"
    else
        eval "$command_to_run"
    fi
}

# --- Phase 1: Reconnaissance (No changes) ---
function reconnaissance() {
    echo -e "\n${PURPLE}=============== 🕵️  Phase 1: Reconnaissance ===============${NC}"
    local all_subs
    local ip_regex='^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$'
    if [[ $TARGET =~ $ip_regex ]]; then all_subs="$TARGET"; else all_subs=$( (subfinder -d "$TARGET" -silent; assetfinder --subs-only "$TARGET") | sort -u ); fi
    echo -e "${GREEN}Found $(echo "$all_subs" | wc -l) potential subdomains.${NC}"; if [ "$LOGGING_ENABLED" = true ]; then echo "$all_subs" > "$RECON_DIR/all_subs.txt"; fi
    export -f check_host; LIVE_HOSTS=$(echo "$all_subs" | parallel -j "$PROBE_JOBS" check_host); unset -f check_host
    if [ -z "$LIVE_HOSTS" ]; then echo -e "${YELLOW}[!] No live hosts found. Skipping remaining steps.${NC}"; return; fi
    echo -e "\n${GREEN}Found $(echo "$LIVE_HOSTS" | wc -l) live host(s):${NC}"; echo -e "${CYAN}$LIVE_HOSTS${NC}"; if [ "$LOGGING_ENABLED" = true ]; then echo "$LIVE_HOSTS" > "$RECON_DIR/live_hosts.txt"; fi
    echo -e "\n${CYAN}[+] Identifying web server technologies with curl...${NC}"; while read -r host; do echo -e "${YELLOW}--- Headers for $host ---${NC}"; run_and_log "curl -s -I '$host' | grep -iE '^(Server:|X-Powered-By:)'" "$RECON_DIR/tech_headers.txt"; done <<< "$LIVE_HOSTS"
    echo -e "\n${CYAN}[+] Checking for WAF with Wafw00f...${NC}"; run_and_log "wafw00f -i <(echo \"\$LIVE_HOSTS\")" "$RECON_DIR/waf_detect.txt"
    echo -e "\n${CYAN}[+] Scanning ports and services with Nmap...${NC}"; run_and_log "nmap -sV --top-ports 1000 '$TARGET'" "$RECON_DIR/nmap_scan.txt"
}

check_host() {
    local host="$1"; if curl -s --head --connect-timeout 5 "https://$host" > /dev/null; then echo "https://$host"; elif curl -s --head --connect-timeout 5 "http://$host" > /dev/null; then echo "http://$host"; fi
}

# --- Phase 2: Advanced Intelligence ---
function advanced_intelligence_modules() {
    echo -e "\n${PURPLE}=============== 🧠  Phase 2: Advanced Intelligence Modules ===============${NC}"
    
    if [ -z "$LIVE_HOSTS" ]; then
        echo -e "${YELLOW}[!] No live hosts to analyze. Skipping advanced modules.${NC}"
        return
    fi
    
    if command -v "linkfinder.py" &> /dev/null; then
        js_intelligence_module_v4
    else
        echo -e "\n${YELLOW}[~] Skipping JavaScript Intelligence module: linkfinder.py not found.${NC}"
    fi
    
    secret_scanning_module
}

# --- NEW v4.4: Robust JS Intelligence Module ---
function js_intelligence_module_v4() {
    echo -e "\n${CYAN}[+] Module: JavaScript Intelligence${NC}"
    local total_hosts
    total_hosts=$(echo "$LIVE_HOSTS" | wc -l)
    local current_host_num=0
    
    while read -r host; do
        current_host_num=$((current_host_num + 1))
        echo -e "\n${BLUE}--- Finding JS on host $current_host_num/$total_hosts: $host ---${NC}"
        
        # Use feroxbuster to find only JS files (-x js), extract the URL, and run silently
        local js_files_on_host
        js_files_on_host=$(feroxbuster -u "$host" -w "$WORDLIST_PATH" -x js --no-recursion --silent | grep "200" | awk '{print $2}')

        if [ -z "$js_files_on_host" ]; then
            echo -e "${YELLOW}[-] No JavaScript files found on $host.${NC}"
            continue # Move to the next host
        fi

        echo -e "${GREEN}Found $(echo "$js_files_on_host" | wc -l) JS files on $host. Analyzing with LinkFinder...${NC}"
        if [ "$LOGGING_ENABLED" = true ]; then echo "$js_files_on_host" >> "$ADVANCED_DIR/js_files_found.txt"; fi
        
        # --- FIX v4.4: Call linkfinder directly to avoid quoting issues with eval ---
        while read -r js_file; do
            if [ -n "$js_file" ]; then
                echo -e "${YELLOW}--- Analyzing $js_file ---${NC}"
                if [ "$LOGGING_ENABLED" = true ]; then
                    linkfinder.py -i "$js_file" -o cli 2>&1 | tee -a "$ADVANCED_DIR/linkfinder_results.txt"
                else
                    linkfinder.py -i "$js_file" -o cli
                fi
            fi
        done <<< "$js_files_on_host"
    done <<< "$LIVE_HOSTS"
}

function secret_scanning_module() {
    echo -e "\n${CYAN}[+] Module: Secret Scanning - Checking for exposed .git directories...${NC}"
    local git_found=false
    while read -r host; do
        if curl -s --head --connect-timeout 5 "$host/.git/config" | head -n 1 | grep -q "200 OK"; then
            git_found=true; local temp_git_dir; temp_git_dir=$(mktemp -d)
            echo -e "${GREEN}[!] Exposed .git directory found at: $host/.git/${NC}"
            if git clone "$host/.git/" "$temp_git_dir"; then
                run_and_log "gitleaks detect -s '$temp_git_dir' -v" "$ADVANCED_DIR/gitleaks_results_$(basename "$host").txt"
            fi
            rm -rf "$temp_git_dir"
        fi
    done <<< "$LIVE_HOSTS"
    if [ "$git_found" = false ]; then echo -e "${YELLOW}[-] No exposed .git directories found.${NC}"; fi
}

# --- Phase 3 & 4 (omitted for brevity, no changes) ---
function scanning() {
    echo -e "\n${PURPLE}=============== 🛡️  Phase 3: Vulnerability Scanning ===============${NC}"
    if [ -z "$LIVE_HOSTS" ]; then return; fi
    echo -e "\n${CYAN}[+] Running automated vulnerability scan with Nuclei...${NC}"
    run_and_log "echo \"\$LIVE_HOSTS\" | nuclei -c $THREADS" "$SCAN_DIR/nuclei_results.txt"
    # ... other scanning tools
}
function specific_checks() { echo -e "\n${PURPLE}=============== 🎯  Phase 4: Specific Checks ===============${NC}"; }
function reporting() { :; } # Placeholder

# =============================================================================
# MAIN EXECUTION
# =============================================================================

print_banner

SCAN_MODE="full"
TARGET=""
while [[ $# -gt 0 ]]; do key="$1"; case $key in --mode) SCAN_MODE="$2"; shift; shift ;; -o|--output) LOGGING_ENABLED=true; shift ;; *) TARGET="$1"; shift ;; esac; done
if [ -z "$TARGET" ]; then usage; fi

if [ "$LOGGING_ENABLED" = true ]; then
    TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
    RESULTS_DIR="VA_Results_${TARGET}_${TIMESTAMP}"
    RECON_DIR="$RESULTS_DIR/1_Recon"
    ADVANCED_DIR="$RESULTS_DIR/2_Advanced_Intel"
    SCAN_DIR="$RESULTS_DIR/3_Scanning"
    SPECIFIC_DIR="$RESULTS_DIR/4_Specific_Checks"
    mkdir -p "$RECON_DIR" "$ADVANCED_DIR" "$SCAN_DIR" "$SPECIFIC_DIR"
    echo -e "${BLUE}[*] 📂  Logging enabled. Results will be saved to: $RESULTS_DIR${NC}"
fi

echo -e "${BLUE}======================================================${NC}"
echo -e "${YELLOW}Target             :${NC} $TARGET"
echo -e "${YELLOW}Scan Mode          :${NC} $SCAN_MODE"
echo -e "${YELLOW}Logging            :${NC} $LOGGING_ENABLED"
echo -e "${YELLOW}Threads            :${NC} $THREADS"
echo -e "${BLUE}======================================================${NC}"

check_dependencies

case "$SCAN_MODE" in
    full)
        reconnaissance
        if [ -n "$LIVE_HOSTS" ]; then
            advanced_intelligence_modules
            scanning
            specific_checks
        fi
        ;;
    recon)
        reconnaissance
        ;;
    fast)
        reconnaissance # Fast scan now equals recon
        ;;
    *)
        echo -e "${RED}[!] ❌ Invalid mode '$SCAN_MODE'${NC}"
        usage
        ;;
esac

reporting

echo -e "\n${GREEN}======================================================${NC}"
echo -e "${GREEN}      ✨  GUNuVA Scan Finished! ✨"
echo -e "${GREEN}======================================================${NC}\n"

exit 0
