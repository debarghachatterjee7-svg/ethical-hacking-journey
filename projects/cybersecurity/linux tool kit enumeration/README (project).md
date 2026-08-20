# Administrative Dashboard System — Linux Enumeration Toolkit

**Main Script:** `enumtool.sh`  
**Project Type:** Bash / Linux / Cybersecurity Learning Project  
**Current Milestone:** Day 47 (Active Refinement Phase)  
**Primary Language:** Bash  
**Environment:** Linux / WSL2  
**Status:** Operational & Stable

---

## 📅 Project Development Timeline

### 🔸 Day 45 — Debugging & Kernel Tracking Fixes
* Focused heavily on troubleshooting unexpected bugs within the core modules [source: 2].
* Discovered an edge-case error in the `uname -r` execution sequence inside the **OS & Kernel Overview** telemetry module.
* Patched the variable assignment layout to properly evaluate kernel strings across differing host targets without throwing blank fields.

### 🔸 Day 46 — Unexpected System Break
* No code additions or document revisions were committed due to an unplanned development break.

### 🔸 Day 47 — Current Milestone (Feature Expansion & Readme Sync)
* Re-synchronized the complete application framework after the prior downtime.
* Integrated the brand-new **CPU & RAM Stats** block leveraging `lscpu` and `free -h` metrics.
* Implemented the student-friendly automated workspace directory archiver utility via `tar -czf`.
* Refreshed all primary architectural layouts, troubleshooting logs, and installation mappings to match the finalized codebase structure.

---

## 🖥️ System Interface Blueprint

The interactive console is constructed dynamically via a standard `while true` program loop:

```text
====================================================
       MY LINUX ADMINISTRATIVE DASHBOARD v1.0        
====================================================
Select an operation from the options below:

  [01] Basic System Info      [07] Check Security & SUID
  [02] OS & Kernel Version    [08] List Running Services
  [03] Logged-in Users        [09] Test Critical File Permissions
  [04] CPU & RAM Stats        [10] Run Quick Folder Backup
  [05] Top 5 Heavy Processes   [11] Export Everything to a Log File
  [06] Disk Space & Storage
  [00] Exit Program
----------------------------------------------------
Enter menu selection [0-11]:
```

---

## 🧩 Toolkit Module Breakdown

### 📂 01 | Basic System Info
* **Purpose:** Pulls basic identification metrics from the local machine state [source: 2].
* **Commands Executed:** `hostname`, `whoami`, `uptime -p` [source: 1, 2].

### 📂 02 | OS & Kernel Version
* **Purpose:** Safely reads kernel parameters and queries system release parameters [source: 2].
* **Bug Fix (Day 45):** Patched dynamic string truncation arrays to stop `uname -r` parsing failures.
* **Commands Executable:** `uname -m`, `uname -r`, `cat /etc/os-release` [source: 2].

### 📂 03 | Logged-in Users
* **Purpose:** Monitors account logs and prints total interactive terminal counts [source: 2].
* **Commands Executed:** `who | wc -l`, `wc -l < /etc/passwd` [source: 1].

### 📂 04 | CPU & RAM Stats (New!)
* **Purpose:** Tracks active system engine power, showing specific hardware hardware models and memory tables.
* **Commands Executed:** `lscpu | grep 'Model name'`, `free -h`.

### 📂 05 | Top 5 Heavy Processes
* **Purpose:** Sorts runtime tasks to instantly target resource exhaustion bottlenecks [source: 1, 2].
* **Commands Executed:** `ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6` [source: 1].

### 📂 06 | Disk Space & Storage
* **Purpose:** Monitors block allocations using clean, human-readable file tables [source: 2].
* **Commands Executed:** `df -h | grep -E 'Filesystem|/dev/'`.

### 📂 07 | Check Security & SUID
* **Purpose:** Isolates risky misconfigurations such as active world-writable directories and SUID templates [source: 2].
* **Commands Executed:** `find /usr/bin -perm -4000`, `find /tmp -perm -0002` [source: 1].

### 📂 08 | List Running Services
* **Purpose:** Confirms background engine status while verifying if `systemctl` tooling exists [source: 2].
* **Commands Executed:** `command -v systemctl`, `systemctl list-units --state=running` [source: 1].

### 📂 09 | Test Critical File Permissions
* **Purpose:** Loops across critical authorization arrays to check for access blocks [source: 1, 2].
* **Commands Executed:** `for file in "${files[@]}"; do [ -r "$file" ]` [source: 1].

### 📂 10 | Run Quick Folder Backup (New!)
* **Purpose:** Prompts the operator for directory targets to build instant compressed archive bundles.
* **Commands Executed:** `read source_dir`, `tar -czf backup_name.tar.gz "$source_dir"`.

### 📂 11 | Export Everything to a Log File
* **Purpose:** Generates a persistent system analysis report file, scrubbing colors using regular patterns [source: 1, 2].
* **Commands Executed:** `sed -i -r "s/\x1B\[([0-9]{1,2}(;[0-9]{1,2})?)?[mGK]//g" report.txt` [source: 1].

---

## 🛠️ Diagnostics & Verification Blueprint

To maintain file verification standards, ensure the runtime code blocks pass these four target tests prior to deployment [source: 2]:

1. **Syntax Integrity Check** [source: 2]
   ```bash
   bash -n enumtool.sh
   ```
2. **Interactive Manual Launch** [source: 2]
   ```bash
   chmod +x enumtool.sh && ./enumtool.sh
   ```
3. **Verbose Tracing Protocol** [source: 2]
   ```bash
   bash -x enumtool.sh
   ```
4. **Data Integrity Verification** (Learned Concept) [source: 2]
   ```bash
   md5sum enumtool.sh
   sha256sum enumtool.sh
   ```

---

## 🗂️ Recommended Project Directory Map

Keep your laboratory directories organized using this standardized file deployment template to ensure seamless project evaluations [source: 2]:

```text
linux-enum-toolkit/
├── projects/
│   └── enumtool.sh             # Main active dashboard executable
├── README.md                   # Updated Day 047 documentation handbook
├── journal/
│   ├── day45_debugging.md      # Debug records & kernel fix breakdowns
│   ├── day46_break.md          # Log note documenting system break
│   └── day47_expansion.md      # CPU/RAM additions & backup logging
├── screenshots/
│   ├── ss074_permissions.md    # Option 07 runtime terminal verification
│   └── ss075_network.md        # Option 05 network link interface verification
└── reports/
    └── student_system_report.txt  # Automated diagnostic log export
```

---

## ⚠️ Academic Disclaimer & Responsible Use

This script was constructed for educational purposes on personal machines, Linux sandbox builds, and certified academic laboratory networks [source: 2]. Always verify file write authorizations prior to executing tracking scripts or generating compressed directory archives on corporate or secondary networks [source: 2].

***

*Developed step-by-step by an aspiring SysAdmin | Core Principle: Understand every flag, patch every bug, document every change.* [source: 2]