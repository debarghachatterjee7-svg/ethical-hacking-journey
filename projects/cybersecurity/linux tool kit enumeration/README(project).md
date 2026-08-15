# 🛡️ Linux Enumeration Toolkit

**Title:** Linux Enumeration Toolkit  
**Version:** v0.1 — Development Build  
**Primary Language:** Bash  
**Platform:** Linux  
**Project Type:** Cybersecurity / Linux / Bash Learning Project  
**Current Milestone:** Day 42  
**Status:** 🚧 In Development

---

## 📖 Description

The **Linux Enumeration Toolkit** is a Bash-based command-line project being developed as part of a structured cybersecurity learning journey.

The project combines Linux command-line knowledge with Bash programming to create an interactive toolkit capable of collecting and presenting useful information about the local Linux environment.

The purpose is not simply to create a large script. The main objective is to understand how Linux commands, Bash programming constructs, input/output handling, functions, loops, conditional logic, and command-line utilities can be combined into a structured application.

The project is being developed progressively. Each module is learned, tested manually, implemented in Bash, connected to the main menu, tested again, documented, and committed to Git.

The current project focuses on **local Linux information and safe enumeration for learning and authorized environments**.

---

# 🎯 Project Objectives

## 1. Learn Bash Through a Real Project

This project provides practical use of:

- Variables
- Functions
- `while` loops
- `case` statements
- `if` conditions
- `read`
- Command substitution
- Exit statuses
- Input validation
- Error handling
- Pipes
- Redirection
- Linux command integration

## 2. Strengthen Linux Fundamentals

The project reinforces:

- System identification
- Kernel information
- Users and groups
- Processes
- Network interfaces
- Routing
- Filesystems
- Storage
- Permissions
- Services

## 3. Build Cybersecurity Foundations

Understanding Linux provides a foundation for later study of:

- Networking
- Web security
- API security
- Cryptography
- Reverse engineering
- Security scripting
- More advanced cybersecurity topics

## 4. Learn Real Project Development

The project also develops:

- Planning
- Modular design
- Testing
- Debugging
- Documentation
- Git
- GitHub
- Incremental development
- Meaningful commits

---

# 🧠 Learning Philosophy

The project follows:

```text
LEARN
  ↓
UNDERSTAND
  ↓
TEST MANUALLY
  ↓
IMPLEMENT
  ↓
CONNECT TO MENU
  ↓
TEST
  ↓
DEBUG
  ↓
DOCUMENT
  ↓
COMMIT
  ↓
IMPROVE
```

A module is considered genuinely learned when I can explain:

1. What the Linux command does.
2. Why it is useful.
3. What the Bash code does.
4. Why the function is structured that way.
5. How the output is obtained.
6. How the module was tested.
7. What happens when something goes wrong.

---

# 🏗️ Current Project Architecture

Current repository:

```text
linux-enum-toolkit/
│
├── enumtool.sh
├── README.md
└── screenshots/
```

Conceptually:

```text
                 LINUX ENUMERATION TOOLKIT
                              │
                       Main Bash Script
                              │
                    ┌─────────┴─────────┐
                    │                   │
                Menu System        Module Functions
                    │                   │
              ┌─────┼─────┐       ┌────┼────┬────┐
              │     │     │       │    │    │    │
            Input  Case  Loop   System OS Users Processes
                                      │
                                   Network
                                      │
                                   Storage
```

As the project grows, it may eventually be split into multiple files if that improves maintainability. For now, one main script keeps the Bash architecture easy to understand.

---

# 🖥️ Current Menu

```text
========================================
       LINUX ENUMERATION TOOLKIT
========================================

1. System Information
2. OS & Kernel
3. Users & Groups
4. Processes
5. Network
6. Storage
7. Permissions
8. Services
9. Important Files
10. Generate Report
0. Exit
```

---

# 🚀 Current Feature Status

| # | Module | Status |
|---:|---|---|
| 1 | System Information | ✅ Implemented |
| 2 | OS & Kernel | ✅ Implemented |
| 3 | Users & Groups | ✅ Implemented |
| 4 | Processes | ✅ Implemented |
| 5 | Network Information | ✅ Implemented |
| 6 | Storage Information | ✅ Implemented |
| 7 | Permissions | ⏳ Planned |
| 8 | Services | ⏳ Planned |
| 9 | Important Files | ⏳ Planned |
| 10 | Generate Report | ⏳ Planned |
| 0 | Exit | ✅ Implemented |

---

# 🔎 Implemented Modules

## 1. System Information

Collects basic information such as:

- Hostname
- Current user
- Uptime
- Kernel release

Commands:

```bash
hostname
whoami
uptime
uname -r
```

The project uses command substitution to capture command output.

Example:

```bash
kernel_version=$(uname -r)
```

---

## 2. OS & Kernel Information

Important commands studied:

```bash
uname
uname -r
uname -a
uname -m
cat /etc/os-release
```

### `uname`

Provides Unix/Linux system and kernel information.

```bash
uname
```

System/kernel name.

```bash
uname -r
```

Kernel release.

```bash
uname -m
```

Machine architecture.

```bash
uname -a
```

Broader system information.

Memory model:

```text
uname
 ├── -r → release
 ├── -m → machine
 └── -a → all
```

---

## 3. Users & Groups

Commands:

```bash
whoami
id
groups
```

Concepts:

- Username
- UID
- GID
- Group membership

This module provides a foundation for the later Permissions module.

---

## 4. Process Information

Commands:

```bash
ps
ps aux
```

This module reinforces process concepts and previously learned command-line tools such as:

```bash
grep
wc
head
tail
sort
```

and pipelines.

---

## 5. Network Information

Commands:

```bash
ip addr
ip route
```

Concepts:

- Network interfaces
- IP addresses
- Routing information

The focus is local information gathering and Linux networking education.

---

## 6. Storage Information

Commands studied:

```bash
df -h
lsblk
du -sh .
```

Concepts:

- Filesystem usage
- Block devices
- Directory size
- Storage organization

---

# 🧩 Bash Concepts Used

## Shebang

```bash
#!/bin/bash
```

Specifies Bash as the interpreter.

## Variables

Store and reuse values.

## Functions

Current functions include concepts such as:

```text
show_banner()
show_menu()
system_info()
os_kernel_info()
users_groups_info()
process_info()
network_info()
storage_info()
```

## `while`

Keeps the menu running until exit.

## `case`

Selects the module based on user input.

## `read`

Receives user input.

## Command Substitution

```bash
value=$(command)
```

Captures command output.

## Exit Status

```bash
$?
```

Represents the previous command's exit status.

## Executable Permission

```bash
chmod +x enumtool.sh
```

Allows:

```bash
./enumtool.sh
```

---

# 🐧 Linux Commands Practiced

```text
pwd
cd
ls
cat
nano
head
tail
grep
wc
find
sort
uniq
echo
hostname
whoami
uptime
uname
ps
ip
df
du
lsblk
id
groups
```

Previously learned shell concepts include:

```text
Pipes
Output redirection
Error redirection
Standard output
Standard error
Command chaining
```

---

# 🔐 MD5 and Checksum Learning

Checksum concepts were also studied before the project.

Examples:

```bash
md5sum filename
```

and:

```bash
echo -n "hello" | md5sum
```

Lessons:

- File contents affect a checksum.
- Changing input changes the checksum.
- `echo -n` avoids adding a newline when hashing text.
- Checksums are useful for integrity concepts.
- MD5 is not considered a modern secure cryptographic hash for security-sensitive applications.

The project may later use stronger checksum concepts such as SHA-256 where appropriate.

---

# 🧪 Testing and Debugging

## Syntax Check

```bash
bash -n enumtool.sh
```

Checks Bash syntax without executing the script.

## Execution Trace

```bash
bash -x enumtool.sh
```

Shows commands as Bash executes them.

## Input Testing

Valid:

```text
1
2
3
4
5
6
0
```

Invalid:

```text
abc
99
-1
blank input
```

The program should remain usable after invalid input.

---

# 📸 Screenshot Documentation

Three milestone screenshots document:

### SS071 — Clean Exit Test
Shows the program terminating correctly through the Exit option.

### SS072 — Invalid Input Handling
Shows an invalid menu choice being handled without crashing.

### SS073 — Linux System Information Output
Shows a working information module and formatted Linux/system details.

Screenshots provide evidence of actual execution and testing.

---

# 📚 Development Timeline

## Day 41 — Bash Project Foundation

- Created the project directory.
- Created `enumtool.sh`.
- Added the Bash shebang.
- Built the banner.
- Built the menu.
- Used functions.
- Used `while`.
- Used `case`.
- Used `read`.
- Added invalid-input handling.
- Added clean exit handling.
- Started the System Information module.
- Introduced command substitution.
- Tested the first project version.

## Day 42 — Core Enumeration Modules

- Added OS & Kernel information.
- Studied `uname`.
- Studied `uname -r`.
- Studied `uname -a`.
- Studied `uname -m`.
- Added Users & Groups information.
- Added Process information.
- Added Network information.
- Added Storage information.
- Connected modules to the menu.
- Tested the project.
- Prepared project documentation.
- Prepared screenshot documentation.
- Prepared GitHub commits.

---

# 🗺️ Future Development Roadmap

## Phase 1 — Foundation
**Status: ✅ Complete**

- Bash script
- Menu
- Functions
- Loop
- `case`
- Input handling
- Error handling
- Exit

## Phase 2 — Core Linux Enumeration
**Status: ✅ Current milestone**

- System Information
- OS & Kernel
- Users & Groups
- Processes
- Network
- Storage

## Phase 3 — Permissions
**Status: ⏳ Planned**

Topics:

- File ownership
- User permissions
- Group permissions
- Permission bits
- `ls -l`
- `stat`
- Safe permission reporting

## Phase 4 — Services
**Status: ⏳ Planned**

Topics:

- Identifying services
- Understanding service management
- Reading service status
- Presenting service information

## Phase 5 — Important Files
**Status: ⏳ Planned**

Potential information:

- Existence
- Ownership
- Permissions
- Basic configuration awareness

## Phase 6 — Report Generation
**Status: ⏳ Planned**

Concept:

```text
Run Toolkit
    ↓
Collect information
    ↓
Organize results
    ↓
Generate report
    ↓
Save report
```

## Phase 7 — Reliability
**Status: ⏳ Planned**

Potential improvements:

- Command availability checks
- Better error handling
- Input validation
- Missing-file handling
- Permission-error handling

## Phase 8 — Code Quality
**Status: ⏳ Planned**

Review:

- Function organization
- Naming
- Readability
- Repeated code
- Comments
- Maintainability
- Consistent output

## Phase 9 — Final Testing
**Status: ⏳ Planned**

Test all modules, normal input, invalid input, missing commands, unexpected output, and repeated execution.

---

# 🎓 Learning Outcomes

By completion, the target is to confidently explain:

### Bash
- Script startup
- Variables
- Functions
- Loops
- `case`
- `read`
- Command substitution
- Pipes
- Redirection
- Exit status
- Debugging
- Script organization

### Linux
- OS identification
- Kernel information
- Users/groups
- Processes
- Network interfaces
- Routing
- Filesystems
- Storage
- Permissions
- Services

### Development
- Planning
- Modular development
- Testing
- Debugging
- Documentation
- Git
- GitHub
- Meaningful commits

---

# 🛡️ Responsible Use

This project is intended for:

- Linux education
- Bash education
- Cybersecurity learning
- System administration learning
- Local system enumeration
- Authorized environments

It is not intended for unauthorized access or attacks against systems without permission.

---

# ▶️ Running the Toolkit

```bash
cd linux-enum-toolkit
chmod +x enumtool.sh
./enumtool.sh
```

Or:

```bash
bash enumtool.sh
```

---

# 📂 Repository Structure

```text
linux-enum-toolkit/
│
├── enumtool.sh
├── README.md
└── screenshots/
```

---

# 🔄 Git Workflow

```bash
git status
git diff
git add .
git commit -m "Describe the change"
git push
```

The repository is developed incrementally so the Git history records meaningful milestones.

---

# 📌 Day 42 Milestone

## Completed

```text
[✓] Project created
[✓] Bash script
[✓] Shebang
[✓] Banner
[✓] Interactive menu
[✓] Functions
[✓] while loop
[✓] case
[✓] read input
[✓] Invalid input handling
[✓] Clean exit
[✓] System Information
[✓] OS & Kernel
[✓] uname
[✓] uname -r
[✓] uname -a
[✓] uname -m
[✓] Users & Groups
[✓] Processes
[✓] Network
[✓] Storage
[✓] Basic testing
[✓] Documentation
```

## Remaining

```text
[ ] Permissions
[ ] Services
[ ] Important Files
[ ] Report Generation
[ ] Advanced error handling
[ ] Logging
[ ] Final cleanup
[ ] Final testing
```

---

# 📊 Current Progress

```text
Bash Foundation       ████████████████████ 100%
Core Enumeration      ████████████████████ 100%
Permissions           ░░░░░░░░░░░░░░░░░░░░   0%
Services              ░░░░░░░░░░░░░░░░░░░░   0%
Important Files       ░░░░░░░░░░░░░░░░░░░░   0%
Report Generation     ░░░░░░░░░░░░░░░░░░░░   0%
Final Testing         ░░░░░░░░░░░░░░░░░░░░   0%
```

---

# 🏁 Final Objective

The final objective is to build a Bash-based Linux enumeration toolkit that can be explained line by line.

The most important success criterion is not the number of features.

It is being able to answer:

> **What does this code do, why is it written this way, what Linux concept does it use, and how was it tested?**

The project therefore serves two purposes:

1. A practical Linux/Bash tool.
2. A long-term record of the cybersecurity learning process.

---

# 🔁 Development Principle

```text
LEARN
 ↓
BUILD
 ↓
TEST
 ↓
BREAK
 ↓
DEBUG
 ↓
DOCUMENT
 ↓
COMMIT
 ↓
IMPROVE
```

**Learn the command. Understand the concept. Build the module. Test it. Document it. Then move forward.**
