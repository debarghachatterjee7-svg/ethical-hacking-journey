#!/bin/bash

# ==============================================================================
# STUDENT SYSTEM ADMIN DASHBOARD (45-Day Linux Project)
# ==============================================================================

# Simple variables for text colors (Learned in Week 2!)
BOLD="\033[1m"
CYAN="\033[36m"
GREEN="\033[32m"
YELLOW="\033[33m"
RED="\033[31m"
BLUE="\033[34m"
MAGENTA="\033[35m"
RESET="\033[0m"

# Function to clear screen and show a clean banner
show_banner() {
    clear
    echo "===================================================="
    echo "       MY LINUX ADMINISTRATIVE DASHBOARD v1.0        "
    echo "===================================================="
}

# The main menu interface using simple echo statements
show_menu() {
    echo -e "${BOLD}Choose a tool from the menu:${RESET}\n"
    echo -e "  ${GREEN}[1]${RESET} Basic System Info      ${GREEN}[7]${RESET} Check Security & SUID"
    echo -e "  ${GREEN}[2]${RESET} OS & Kernel Version    ${GREEN}[8]${RESET} List Running Services"
    echo -e "  ${GREEN}[3]${RESET} Logged-in Users        ${GREEN}[9]${RESET} Test Critical File Permissions"
    echo -e "  ${GREEN}[4]${RESET} CPU & RAM Stats        ${GREEN}[10]${RESET} Run Quick Folder Backup"
    echo -e "  ${GREEN}[5]${RESET} Top 5 Heavy Processes   ${GREEN}[11]${RESET} Export Everything to a Log File"
    echo -e "  ${GREEN}[6]${RESET} Disk Space & Storage"
    echo -e "  ${RED}[0]${RESET} Exit Program"
    echo "----------------------------------------------------"
    echo -n "Enter choice [0-11]: "
    read choice
}

# 1. Basic System Info
system_info() {
    echo -e "\n${BLUE}=== [1] BASIC SYSTEM INFO ===${RESET}"
    echo "Hostname:      $(hostname)"
    echo "Current User:  $(whoami)"
    echo "Uptime:        $(uptime -p)"
}

# 2. OS & Kernel Version
os_kernel_info() {
    echo -e "\n${BLUE}=== [2] OS & KERNEL VERSION ===${RESET}"
    # Read the pretty name from os-release file if it exists
    if [ -f /etc/os-release ]; then
        echo -n "Operating System: "
        grep "PRETTY_NAME" /etc/os-release | cut -d'"' -f2
    fi
    echo "Kernel Architecture: $(uname -m)"
    echo "Kernel Release:      $(uname -r)"
}

# 3. Logged-in Users
users_groups_info() {
    echo -e "\n${BLUE}=== [3] USERS AND LOGGED-IN SESSIONS ===${RESET}"
    echo "Total registered accounts in /etc/passwd: $(wc -l < /etc/passwd)"
    echo "Total active user sessions right now: $(who | wc -l)"
    echo "----------------------------------------------------"
    echo "Details of current users:"
    who
}

# 4. CPU & RAM Stats (Great practice for parsing free and lscpu)
cpu_ram_stats() {
    echo -e "\n${BLUE}=== [4] CPU & RAM STATS ===${RESET}"
    echo "CPU Model: $(lscpu | grep 'Model name' | cut -d':' -f2 | sed 's/^[ \t]*//')"
    echo "----------------------------------------------------"
    echo "Memory Usage (RAM):"
    free -h
}

# 5. Top 5 Heavy Processes
processes_info() {
    echo -e "\n${BLUE}=== [5] TOP 5 CPU CONSUMING PROCESSES ===${RESET}"
    echo "Total active processes running: $(ps aux | wc -l)"
    echo "----------------------------------------------------"
    # Show headers plus top 5 lines
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

# 6. Disk Space & Storage
storage_info() {
    echo -e "\n${BLUE}=== [6] DISK SPACE & STORAGE ===${RESET}"
    # -h makes it human readable (GigaBytes/MegaBytes)
    df -h | grep -E 'Filesystem|/dev/'
}

# 7. Check Security & SUID
permissions_info() {
    echo -e "\n${BLUE}=== [7] SECURITY & SUID BINARIES ===${RESET}"
    echo "Looking for SUID files in /usr/bin (potential privilege escalations):"
    # Find files with permission 4000 and limit to top 5 so it doesn't spam
    find /usr/bin -perm -4000 2>/dev/null | head -n 5
    echo "----------------------------------------------------"
    echo "Looking for files anyone can write to in /tmp:"
    find /tmp -maxdepth 2 -perm -0002 -type f 2>/dev/null | head -n 5
}

# 8. List Running Services
services_info() {
    echo -e "\n${BLUE}=== [8] ACTIVE SERVICES ===${RESET}"
    # Check if systemd exists first, otherwise fall back to service command
    if command -v systemctl &>/dev/null; then
        systemctl list-units --type=service --state=running --no-pager | head -n 12
    else
        echo "systemctl not found. Trying legacy service tool:"
        service --status-all 2>/dev/null | grep "+" | head -n 10
    fi
}

# 9. Test Critical File Permissions (Great example of using a basic 'for' loop)
important_files_info() {
    echo -e "\n${BLUE}=== [9] CRITICAL FILES PERMISSIONS CHECK ===${RESET}"
    
    # Store files in a standard array
    files=("/etc/passwd" "/etc/shadow" "/etc/fstab")
    
    for file in "${files[@]}"; do
        if [ -r "$file" ]; then
            echo -e "  $file : ${GREEN}Readable${RESET}"
        else
            echo -e "  $file : ${RED}Access Denied / Unreadable${RESET}"
        fi
    done
}

# 10. Run Quick Folder Backup (Brand new student-friendly utility feature!)
run_backup() {
    echo -e "\n${BLUE}=== [10] QUICK FOLDER BACKUP TOOL ===${RESET}"
    echo -n "Enter the full path of the folder you want to backup: "
    read source_dir

    if [ -d "$source_dir" ]; then
        backup_file="backup_$(basename "$source_dir")_$(date +%Y%m%d).tar.gz"
        echo "Creating compressed backup file: $backup_file..."
        tar -czf "$backup_file" "$source_dir" 2>/dev/null
        echo -e "${GREEN}Success! Backup saved in your current working directory.${RESET}"
    else
        echo -e "${RED}Error: That directory does not exist!${RESET}"
    fi
}

# 11. Export Everything to a Log File
generate_report() {
    local report_file="student_system_report.txt"
    echo -e "\n${MAGENTA}[*] Generating system report text file...${RESET}"

    # Grouping functions and dumping them clean into a file
    {
        echo "===================================================="
        echo "        AUTOMATED SYSTEM LOG DIAGNOSTIC REPORT      "
        echo "        Generated on: $(date)"
        echo "===================================================="
        system_info
        os_kernel_info
        users_groups_info
        cpu_ram_stats
        processes_info
        storage_info
        permissions_info
        services_info
        important_files_info
    } > "$report_file"

    # Cleaning ANSI escape color codes from text output file using basic sed
    sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" "$report_file"
    echo -e "${GREEN}[✓] Saved to: $(pwd)/$report_file${RESET}"
}

# ==============================================================================
# MAIN PROGRAM LOOP
# ==============================================================================
while true
do
    show_banner
    show_menu

    # Handle menu responses
    case "$choice" in
        1)  system_info ;;
        2)  os_kernel_info ;;
        3)  users_groups_info ;;
        4)  cpu_ram_stats ;;
        5)  processes_info ;;
        6)  storage_info ;;
        7)  permissions_info ;;
        8)  services_info ;;
        9)  important_files_info ;;
        10) run_backup ;;
        11) generate_report ;;
        0)
            echo -e "\n${GREEN}Exiting script. Thanks for using my dashboard!${RESET}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}[!] Invalid choice! Please select an option from 0 to 11.${RESET}"
            ;;
    esac

    echo ""
    echo -n "Press [Enter] to return to the menu..."
    read press_enter
done
