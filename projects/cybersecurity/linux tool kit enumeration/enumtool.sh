#!/bin/bash

# ==============================================================================
# ADMINISTRATIVE DASHBOARD
# ==============================================================================

# Custom Color Palette & Text Formatting
BOLD="\\033[1m"
CYAN="\\033[36m"
GREEN="\\033[32m"
YELLOW="\\033[33m"
RED="\\033[31m"
BLUE="\\033[34m"
MAGENTA="\\033[35m"
RESET="\\033[0m"

# Render Styled Header Banner
show_banner() {
    clear
    echo -e "${CYAN}====================================================${RESET}"
    echo -e "${BOLD}${CYAN}          ADMINISTRATIVE DASHBOARD SYSTEM${RESET}"
    echo -e "${CYAN}====================================================${RESET}"
}

# Render Main Navigation Menu
show_menu() {
    echo -e "${BOLD}Select an operation from the options below:${RESET}\n"
    echo -e "  ${GREEN}[01]${RESET} System Information     ${GREEN}[06]${RESET} Storage Information"
    echo -e "  ${GREEN}[02]${RESET} OS & Kernel Overview   ${GREEN}[07]${RESET} Security Permissions"
    echo -e "  ${GREEN}[03]${RESET} Users & Groups         ${GREEN}[08]${RESET} Active Services"
    echo -e "  ${GREEN}[04]${RESET} Process Diagnostics    ${GREEN}[09]${RESET} Important Files Check"
    echo -e "  ${GREEN}[05]${RESET} Network Status         ${GREEN}[10]${RESET} Generate Full Report"
    echo -e "  ${RED}[00]${RESET} Exit Dashboard"
    echo -e "${CYAN}----------------------------------------------------${RESET}"
    read -p "Enter menu selection [0-10]: " choice
}

# Module 1: System Information
system_info() {
    local host=$(hostname)
    local current_user=$(whoami)
    local system_uptime=$(uptime -p 2>/dev/null || uptime)
    local kernel_version=$(uname -r)

    echo -e "\n${BOLD}${BLUE}[+] SYSTEM INFORMATION${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    printf "  %-18s : %s\n" "Hostname" "$host"
    printf "  %-18s : %s\n" "Current User" "$current_user"
    printf "  %-18s : %s\n" "System Uptime" "$system_uptime"
    printf "  %-18s : %s\n" "Kernel Release" "$kernel_version"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
}

# Module 2: OS & Kernel Information
os_kernel_info() {
    local os_name="Unknown"
    if [ -f /etc/os-release ]; then
        os_name=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    fi
    local kernel_type=$(uname -s)
    local architecture=$(uname -m)

    echo -e "\n${BOLD}${BLUE}[+] OS & KERNEL OVERVIEW${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    printf "  %-18s : %s\n" "OS Release" "$os_name"
    printf "  %-18s : %s\n" "Kernel Architecture" "$kernel_type ($architecture)"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
}

# Module 3: Users & Groups Information
users_groups_info() {
    local active_users=$(who | wc -l)
    local total_users=$(wc -l < /etc/passwd)
    local total_groups=$(wc -l < /etc/group)

    echo -e "\n${BOLD}${BLUE}[+] USERS & GROUPS METRICS${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    printf "  %-22s : %s\n" "Active User Sessions" "$active_users"
    printf "  %-22s : %s\n" "Registered Accounts" "$total_users"
    printf "  %-22s : %s\n" "Configured Groups" "$total_groups"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    echo -e "${BOLD}Logged-in Session Details:${RESET}"
    who | awk '{print "  - " $0}'
}

# Module 4: Process Diagnostics
processes_info() {
    local running_proc=$(ps -axh 2>/dev/null | wc -l)

    echo -e "\n${BOLD}${BLUE}[+] PROCESS DIAGNOSTICS${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    printf "  %-22s : %s\n" "Total Active Processes" "$running_proc"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    echo -e "${BOLD}Top 5 Resource-Consuming Processes (by CPU):${RESET}\n"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

# Module 5: Network Information
network_info() {
    local primary_ip=$(hostname -I 2>/dev/null | awk '{print $1}')
    [ -z "$primary_ip" ] && primary_ip="Unavailable"
    
    local ext_ip=$(curl -s --max-time 3 ifconfig.me 2>/dev/null || echo "Offline / Timeout")

    echo -e "\n${BOLD}${BLUE}[+] NETWORK STATUS${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    printf "  %-20s : %s\n" "Local IP Address" "$primary_ip"
    printf "  %-20s : %s\n" "External IP Address" "$ext_ip"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    echo -e "${BOLD}Active Interface Summary:${RESET}"
    ip -br link 2>/dev/null || echo "  Unable to fetch interface link data."
}

# Module 6: Storage Information
storage_info() {
    echo -e "\n${BOLD}${BLUE}[+] STORAGE INFORMATION${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    df -h --total 2>/dev/null | grep -E 'Filesystem|total'
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    echo -e "${BOLD}Detailed Mount Point Layout:${RESET}\n"
    df -h
}

# Module 7: Security & Permissions Check
permissions_info() {
    echo -e "\n${BOLD}${BLUE}[+] SECURITY & PERMISSIONS AUDIT${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    echo -e "${BOLD}World-Writable Files in /tmp (Sample):${RESET}"
    find /tmp -maxdepth 2 -perm -0002 -type f 2>/dev/null | head -n 5 | awk '{print "  - " $0}' || echo "  None identified."
    
    echo -e "\n${BOLD}SUID Binary Sample (/usr/bin):${RESET}"
    find /usr/bin -perm -4000 2>/dev/null | head -n 5 | awk '{print "  - " $0}' || echo "  None identified."
    echo -e "${BLUE}----------------------------------------------------${RESET}"
}

# Module 8: Active Services
services_info() {
    echo -e "\n${BOLD}${BLUE}[+] ACTIVE SERVICES STATUS${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    if command -v systemctl &> /dev/null; then
        echo -e "${BOLD}Top Running Systemd Services:${RESET}\n"
        systemctl list-units --type=service --state=running --no-pager | head -n 12
    else
        echo -e "  ${YELLOW}[!] systemctl tool unavailable on this environment.${RESET}"
    fi
    echo -e "${BLUE}----------------------------------------------------${RESET}"
}

# Module 9: Important Files Verification
important_files_info() {
    echo -e "\n${BOLD}${BLUE}[+] CRITICAL FILES AUDIT${RESET}"
    echo -e "${BLUE}----------------------------------------------------${RESET}"
    
    local files=("/etc/passwd" "/etc/shadow" "/etc/fstab" "/var/log/syslog")
    for file in "${files[@]}"; do
        if [ -r "$file" ]; then
            printf "  %-22s : ${GREEN}Readable${RESET}\n" "$file"
        elif [ -e "$file" ]; then
            printf "  %-22s : ${RED}Access Denied (Permission Required)${RESET}\n" "$file"
        else
            printf "  %-22s : ${YELLOW}File Not Found${RESET}\n" "$file"
        fi
    done
    echo -e "${BLUE}----------------------------------------------------${RESET}"
}

# Module 10: Export Comprehensive Report
generate_report() {
    local report_file="system_report_$(date +%Y%m%d_%H%M%S).txt"
    echo -e "\n${BOLD}${MAGENTA}[*] GENERATING SYSTEM DIAGNOSTIC REPORT...${RESET}"
    echo -e "Saving report output to ${BOLD}${report_file}${RESET}..."

    {
        echo "===================================================="
        echo "     ADMINISTRATIVE DASHBOARD DIAGNOSTIC REPORT    "
        echo "     Generated On: $(date)"
        echo "===================================================="
        system_info
        os_kernel_info
        users_groups_info
        processes_info
        network_info
        storage_info
        permissions_info
        services_info
        important_files_info
    } | sed -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" > "$report_file"

    echo -e "${GREEN}[✓] Diagnostic report generated successfully!${RESET}"
}

# ==============================================================================
# MAIN PROGRAM LOOP
# ==============================================================================

while true
do
    show_banner
    show_menu

    case "$choice" in
        1|01) system_info ;;
        2|02) os_kernel_info ;;
        3|03) users_groups_info ;;
        4|04) processes_info ;;
        5|05) network_info ;;
        6|06) storage_info ;;
        7|07) permissions_info ;;
        8|08) services_info ;;
        9|09) important_files_info ;;
        10)   generate_report ;;
        0|00)
            echo -e "\n${GREEN}Exiting Administrative Dashboard. Goodbye!${RESET}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}[!] Invalid choice. Please select a valid menu option.${RESET}"
            ;;
    esac

    echo ""
    read -p "Press [Enter] to return to main menu..." confirmation
done
