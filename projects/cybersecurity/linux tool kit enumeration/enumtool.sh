#!/bin/bash

# ==============================================================================
# FUNCTIONS (Defined first so the script knows they exist)
# ==============================================================================

# Aesthetic banner header
show_banner() {
    clear
    echo "========================================"
    echo "       ADMINISTRATIVE DASHBOARD        "
    echo "========================================"
}

# Display menu items exactly matching project specs
show_menu() {
    echo "1. System Information"
    echo "2. OS & Kernel"
    echo "3. Users & Groups"
    echo "4. Processes"
    echo "5. Network Information"
    echo "6. Storage Information"
    echo "7. Permissions"
    echo "8. Services"
    echo "9. Important Files"
    echo "10. Generate Report"
    echo "0. Exit"
    echo "========================================"
    read -p "Enter your choice: " choice
}

# Option 1: System Information
system_info() {
    local host=$(hostname)
    local current_user=$(whoami)
    local system_uptime=$(uptime -p)
    local kernel_version=$(uname -r)

    echo ""
    echo "----------------------------------------"
    echo "           SYSTEM INFORMATION           "
    echo "----------------------------------------"
    echo "Hostname : $host"
    echo "User     : $current_user"
    echo "Uptime   : $system_uptime"
    echo "Kernel   : $kernel_version"
    echo "----------------------------------------"
}

# Option 2: OS & Kernel Information
os_kernel_info() {
    local os_name=$(grep -E '^PRETTY_NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
    local kernel_type=$(uname -s)
    local architecture=$(uname -m)

    echo ""
    echo "----------------------------------------"
    echo "             OS & KERNEL                "
    echo "----------------------------------------"
    echo "OS Release   : $os_name"
    echo "Kernel Type  : $kernel_type"
    echo "Architecture : $architecture"
    echo "----------------------------------------"
}

# Option 3: Users & Groups
users_groups_info() {
    local active_users=$(who | wc -l)
    local total_users=$(wc -l < /etc/passwd)
    local total_groups=$(wc -l < /etc/group)

    echo ""
    echo "----------------------------------------"
    echo "            USERS & GROUPS              "
    echo "----------------------------------------"
    echo "Active User Sessions : $active_users"
    echo "Total System Users   : $total_users"
    echo "Total System Groups  : $total_groups"
    echo "----------------------------------------"
    echo "Currently logged in details:"
    who
}

# Option 4: Processes
processes_info() {
    local running_proc=$(ps -axh | wc -l)

    echo ""
    echo "----------------------------------------"
    echo "               PROCESSES                "
    echo "----------------------------------------"
    echo "Total Running Processes: $running_proc"
    echo "----------------------------------------"
    echo "Top 5 CPU-consuming processes:"
    ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6
}

# Option 5: Network Information
network_info() {
    local primary_ip=$(hostname -I | awk '{print $1}')
    local ext_ip=$(curl -s ifconfig.me || echo "No internet connection")

    echo ""
    echo "----------------------------------------"
    echo "          NETWORK INFORMATION           "
    echo "----------------------------------------"
    echo "Local IP Address    : $primary_ip"
    echo "External IP Address : $ext_ip"
    echo "----------------------------------------"
    echo "Active Network Interfaces:"
    ip -br link
}

# Option 6: Storage Information
storage_info() {
    echo ""
    echo "----------------------------------------"
    echo "          STORAGE INFORMATION           "
    echo "----------------------------------------"
    df -h --total | grep -E 'Filesystem|total'
    echo "----------------------------------------"
    echo "Detailed Disk Space Layout:"
    df -h
}

# ==============================================================================
# MAIN PROGRAM LOOP
=# ==============================================================================

while true
do
    # 1. Render UI components sequentially
    show_banner
    show_menu

    # 2. Evaluate selections using clean function maps
    case "$choice" in
        1)
            system_info
            ;;
        2)
            os_kernel_info
            ;;
        3)
            users_groups_info
            ;;
        4)
            processes_info
            ;;
        5)
            network_info
            ;;
        6)
            storage_info
            ;;
        7|8|9|10)
            echo ""
            echo "[*] Module $choice is flagged NOT TODAY."
            ;;
        0)
            echo ""
            echo "Exiting program. Goodbye!"
            exit 0
            ;;
        *)
            echo ""
            echo "[!] Invalid option."
            ;;
    esac

    # Halt screen wipe so the operator can view statistics
    echo ""
    read -p "Press Enter to continue..." confirmation
done

