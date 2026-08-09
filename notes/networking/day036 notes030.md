# Day 036 — Notes 030
## Bash Automation, Cron, Environment Variables & Dynamic Scripts

> **Purpose:** A compact but deep revision note for Day 036. The goal is not only to remember commands, but to understand how to recognize when a Linux/Bash concept can solve a real problem.

---

## 1. What I Learned Today

Today's main focus was **connecting Bash scripting with Linux automation**.

### New concepts

- Environment variables and how programs inherit them
- `env` and `env | sort`
- `$USER`, `$HOME`, `$PATH`, `$$`
- `unset`
- Quoting variables correctly
- Command substitution: `$(command)`
- Dynamic filenames
- Making Bash scripts executable with `chmod +x`
- Cron and `crontab`
- `crontab -e` and `crontab -l`
- `/etc/cron.d/`
- How cron executes commands automatically
- Checking whether cron is running with `ps -ef | grep cron`
- Using generated files to verify automation
- Connecting processes, users, shells and scheduled jobs

The important shift was:

> **Instead of only running commands manually, I started thinking about how Linux can perform tasks automatically and how I can observe/verify that behavior.**

---

# 2. Environment Variables

Environment variables are values maintained by the shell/environment and made available to programs started from that environment.

Examples:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
env
env | sort
```

### Important variables

| Variable | Meaning | Example use |
|---|---|---|
| `$USER` | Current username | Identify which account is running a script |
| `$HOME` | User's home directory | Build user-specific file paths |
| `$PATH` | Directories searched for commands | Understand command resolution |
| `$$` | PID of the current shell | Identify the current shell process |
| `$SHELL` | User's configured shell | Understand shell environment |
| `$PWD` | Current working directory | Build dynamic paths |
| `$OLDPWD` | Previous working directory | Navigation scripts |
| `$HOSTNAME` | System hostname | Identify a machine |
| `$TERM` | Terminal type | Terminal-dependent scripts |

### Why `env | sort` matters

```bash
env | sort
```

This displays environment variables alphabetically.

That makes a large environment easier to inspect and compare.

**Security relevance:** environment variables can reveal configuration, paths, usernames, runtime information and sometimes accidentally exposed secrets. In real security work, they are useful during system enumeration.

---

# 3. `unset`

`unset` removes a shell variable.

Example:

```bash
NAME="sonu"
echo "$NAME"

unset NAME
echo "$NAME"
```

After `unset`, the variable no longer has its previous value.

### Why this matters

A script may temporarily store information in variables. Removing variables can prevent stale values from affecting later commands.

**Real-life use:** cleanup of temporary configuration/state in scripts.

**Security thinking:** always ask:

> "What information exists in this shell environment, and should it still exist?"

---

# 4. Quoting Variables

Correct:

```bash
echo "$USER"
```

Incorrect:

```bash
echosonu
```

Without the `$` and correct separation, Bash interprets the text as something completely different.

### Basic rule

```bash
"$VARIABLE"
```

is generally the safe form when you want the variable's value treated as one argument.

Quoting becomes especially important when values contain:

- spaces
- special characters
- wildcard characters
- empty values

---

# 5. Command Substitution

Command substitution allows the output of one command to become part of another command.

Modern form:

```bash
$(command)
```

Example:

```bash
echo "User: $(whoami)"
```

Another example:

```bash
cat "/tmp/$(whoami)_lab.txt"
```

If the username is `sonu`, Bash effectively uses:

```text
/tmp/sonu_lab.txt
```

### Why this is powerful

It makes scripts **dynamic**.

Instead of hard-coding:

```bash
/tmp/sonu_lab.txt
```

we can use:

```bash
/tmp/$(whoami)_lab.txt
```

Now the script can work for different users.

---

# 6. Dynamic Bash Scripts

Example concept:

```bash
#!/bin/bash

USER_NAME=$(whoami)
FILE="/tmp/${USER_NAME}_lab.txt"

echo "User: $USER_NAME" > "$FILE"
echo "File created: $FILE"
```

This script:

1. Finds the current user.
2. Stores it in a variable.
3. Builds a filename dynamically.
4. Creates the file.
5. Writes information into it.

### Why this is better than hard-coding

Hard-coded:

```text
/tmp/sonu_lab.txt
```

Dynamic:

```text
/tmp/$(whoami)_lab.txt
```

The second approach is reusable.

---

# 7. `chmod +x`

To execute a script directly:

```bash
chmod +x dynamic.sh
```

Then:

```bash
./dynamic.sh
```

`chmod` changes permissions.

`+x` adds the executable permission.

### Important distinction

Writing a script and executing a script are different things.

```bash
nano script.sh
```

creates/edits it.

```bash
chmod +x script.sh
```

allows direct execution.

```bash
./script.sh
```

runs it.

---

# 8. Cron

## What is cron?

**Cron is a Linux service used to run commands or scripts automatically according to a schedule.**

Instead of manually running:

```bash
./backup.sh
```

every day, cron can execute it automatically.

### Real-life examples

- Daily backups
- Log cleanup
- Monitoring tasks
- Database maintenance
- Report generation
- Temporary-file cleanup
- Automated system jobs

### Security relevance

Cron is extremely important in Linux security because scheduled jobs can:

- perform legitimate maintenance
- execute security monitoring
- create automated backups
- accidentally expose sensitive files
- contain configuration mistakes
- become relevant during authorized CTF/lab enumeration

---

# 9. `crontab`

## Edit user cron jobs

```bash
crontab -e
```

This opens the current user's crontab for editing.

## List current cron jobs

```bash
crontab -l
```

If there are no jobs, Linux may report:

```text
no crontab for user
```

That does not mean cron itself is stopped. It means that particular user does not currently have a personal crontab.

---

# 10. Cron Schedule Structure

A traditional cron entry has five time fields:

```text
minute hour day-of-month month day-of-week command
```

Example:

```text
0 2 * * * /path/to/backup.sh
```

Meaning:

> Run `/path/to/backup.sh` every day at 02:00.

### Five fields

```text
* * * * *
│ │ │ │ │
│ │ │ │ └── day of week
│ │ │ └──── month
│ │ └────── day of month
│ └──────── hour
└────────── minute
```

Common symbols:

- `*` = every possible value
- `,` = multiple values
- `-` = range
- `/` = step interval

---

# 11. `/etc/cron.d/`

System-wide scheduled jobs can be stored in:

```bash
/etc/cron.d/
```

We inspected it with:

```bash
ls /etc/cron.d/
```

This is different from a user's personal crontab.

### Important distinction

```text
crontab -e
```

→ current user's scheduled jobs

```text
/etc/cron.d/
```

→ system configuration files containing scheduled jobs

This distinction is very important during Linux enumeration.

---

# 12. Checking the Cron Process

We used:

```bash
ps -ef | grep cron
```

This helps determine whether a cron process is running and shows matching processes.

Example interpretation:

```text
/usr/sbin/cron -f -P
```

indicates the cron service/process.

### Important lesson

Finding:

```text
grep cron
```

does **not automatically mean cron itself is running**.

The `grep` command also appears because the search command itself contains the word `cron`.

So read the output carefully.

---

# 13. Process IDs and Shells

We revised:

```bash
echo $$
```

`$$` gives the PID of the current shell.

We also used:

```bash
ps
ps -ef
pstree
ps -ef | grep bash
```

### Important fields

| Field | Meaning |
|---|---|
| PID | Process ID |
| PPID | Parent Process ID |
| UID/user | User running the process |
| CMD | Command/process |
| TTY | Terminal associated with process |
| STAT | Process state |
| TIME | CPU time used |

### PID vs PPID

**PID** = identity of the current process.

**PPID** = PID of the process that created/started it.

This gives us a process relationship.

Example:

```text
PID 594
PPID 591
```

means process `594` was started by process `591`.

---

# 14. `pstree`

```bash
pstree
```

shows processes as a tree.

This makes parent-child relationships easier to understand than a flat `ps` listing.

Conceptually:

```text
init
 ├── login
 │    └── bash
 │         └── command
 └── cron
      └── scheduled script
```

### Why this matters

A security analyst often needs to ask:

> "Who started this process?"

and:

> "What processes did this process start?"

That is exactly the type of reasoning PID/PPID and `pstree` support.

---

# 15. Professor Questions — Answers

## Q1. What is an environment variable?

An environment variable is a value available to the shell and usually inherited by programs started from it.

Example:

```bash
echo "$HOME"
```

---

## Q2. Why use `env | sort`?

`env` displays environment variables.

`sort` alphabetically organizes the output, making it easier to inspect.

---

## Q3. What does `unset` do?

It removes a shell variable.

```bash
unset NAME
```

---

## Q4. What does `$$` mean?

It represents the PID of the current shell.

```bash
echo $$
```

---

## Q5. Why use `$(whoami)`?

It dynamically obtains the current username.

This prevents scripts from depending on a hard-coded username.

---

## Q6. What does `chmod +x` do?

It adds executable permission to a file.

---

## Q7. What is cron?

Cron is a Linux scheduling mechanism/service used to execute commands automatically at specified times.

---

## Q8. What is the difference between `crontab -e` and `crontab -l`?

```text
crontab -e → edit scheduled jobs
crontab -l → list scheduled jobs
```

---

## Q9. What is `/etc/cron.d/`?

It is a system location containing cron job configuration files.

---

## Q10. Why did `ps -ef | grep cron` show two lines?

One line can be the actual cron process, while another is often the `grep cron` command itself.

---

## Q11. What is PID?

PID is the unique process ID assigned to a running process.

---

## Q12. What is PPID?

PPID is the PID of the parent process that started the current process.

---

## Q13. Why is `pstree` useful?

It visually shows parent-child process relationships.

---

## Q14. Why is command substitution useful?

It allows command output to be used dynamically inside another command or script.

---

## Q15. Why are dynamic filenames useful?

They allow one script to work for different users, machines or runtime conditions without changing the source code.

---

# 16. Functions / Commands Learned Till Today

This is the cumulative quick-reference section.

## A. Navigation & Files

| Command | Main use |
|---|---|
| `pwd` | Show current directory |
| `cd` | Change directory |
| `ls` | List files |
| `mkdir` | Create directory |
| `touch` | Create empty file |
| `cat` | Display file contents |
| `nano` | Edit text/file |
| `cp` | Copy files/directories |
| `mv` | Move/rename |
| `rm` | Remove |
| `head` | First lines |
| `tail` | Last lines |
| `file` | Identify file type |

---

## B. Searching & Text Processing

| Command | Main use |
|---|---|
| `grep` | Search text/patterns |
| `find` | Find files/directories |
| `sort` | Sort lines |
| `uniq` | Remove adjacent duplicates |
| `wc` | Count lines/words/bytes |
| `echo` | Print text/variables |
| `strings` | Extract readable strings |
| `tr` | Translate/delete characters |
| `cut` | Extract fields/columns |
| `>` | Redirect output |
| `>>` | Append output |
| `2>` | Redirect errors |
| `2>/dev/null` | Discard error output |
| `|` | Pipe output to another command |

---

## C. Compression & Archives

| Command | Use |
|---|---|
| `gzip` | Compress/decompress gzip files |
| `gunzip` | Decompress `.gz` |
| `tar` | Create/extract archives |
| `tar -cvf` | Create tar archive |
| `tar -xvf` | Extract tar archive |
| `tar -czvf` | Create gzip-compressed tar |
| `tar -xzvf` | Extract gzip-compressed tar |
| `bunzip2` | Decompress `.bz2` |

### Remember

`tar` = archive/group files.

`gzip` = compression.

So:

```text
.tar       → archive
.tar.gz    → archive + gzip compression
.tar.bz2   → archive + bzip2 compression
```

---

## D. Processes & Jobs

| Command | Use |
|---|---|
| `ps` | Show processes |
| `ps -aux` | Detailed process listing |
| `ps -ef` | Full process listing |
| `pstree` | Process hierarchy |
| `jobs` | Shell background jobs |
| `kill` | Send signal to process |
| `sleep` | Pause execution |
| `$$` | Current shell PID |

---

## E. Environment & Shell

| Command/variable | Use |
|---|---|
| `env` | Show environment |
| `env \| sort` | Sorted environment |
| `echo "$USER"` | Current user |
| `echo "$HOME"` | Home directory |
| `echo "$PATH"` | Command search path |
| `echo "$$"` | Current shell PID |
| `unset` | Remove variable |
| `whoami` | Current username |
| `which` | Locate executable |
| `printenv` | Display environment variables |
| `$(command)` | Command substitution |

---

## F. Networking Previously Learned

| Command | Use |
|---|---|
| `ip addr` | Show IP addresses/interfaces |
| `ip link` | Show network interfaces/link state |
| `ip route` | Show routing table |
| `ss -tuln` | Show listening TCP/UDP sockets |
| `ping` | Test IP/network reachability |
| `hostname` | Show/change hostname |
| `curl` | Make HTTP/network requests |
| `wget` | Download resources |

### Important networking thought process

When looking at a machine:

```text
1. What interfaces exist?
2. What IP address does each interface have?
3. What route does traffic use?
4. What ports/services are listening?
5. Can I reach the destination?
6. What service is responsible for the port?
```

This is much more useful than memorizing commands separately.

---

# 17. Real-Life Application

The strongest lesson from the current phase is **combining commands**.

For example:

```bash
ps -ef | grep cron
```

is more useful than knowing `ps` and `grep` separately.

Another example:

```bash
cat /tmp/$(whoami)_lab.txt
```

combines:

- `cat`
- command substitution
- variables
- filesystem paths

A more advanced automation idea is:

```text
Cron
 ↓
Bash script
 ↓
Environment variables
 ↓
Dynamic filename
 ↓
Log/output file
 ↓
Verification with ls/cat/ps
```

This is how individual Linux concepts start becoming a working system.

---

# 18. How to Think Like a Security Learner

When given an unfamiliar Linux machine, do not immediately think:

> "Which command should I type?"

Instead think:

### Step 1 — Observe

```text
Who am I?
Where am I?
What machine am I on?
What processes exist?
What services exist?
```

### Step 2 — Identify relationships

```text
Who started this process?
What starts automatically?
Which user owns it?
Where is its executable?
What files does it use?
```

### Step 3 — Automate repetitive work

Ask:

> "Could Bash or cron perform this automatically?"

### Step 4 — Verify

Never assume a command worked.

Check:

```bash
ls
cat
ps
jobs
```

or another appropriate observation command.

### Step 5 — Explain the result

A good ethical hacker should be able to explain:

- what happened
- why it happened
- what evidence proves it
- what the security impact could be
- how to fix or safely reproduce it

---

# 19. Connection to Bandit

Today's concepts are highly relevant to Linux CTFs.

Especially important:

```text
cron
/etc/cron.d/
ps
pstree
PID
PPID
bash
environment variables
$PATH
$USER
$HOME
$(command)
find
grep
cat
permissions
/tmp
redirection
```

A Bandit problem may not require memorizing a special command.

It may require recognizing:

> **"Something is being executed automatically. Where is the scheduled job? What script does it execute? What permissions does that script have? What file does it create?"**

That is the reasoning skill being developed.

---

# 20. Today's Mind Map

```text
                    DAY 036
                       │
        ┌──────────────┴──────────────┐
        │                             │
 Environment                     Automation
 Variables                         │
        │                          Cron
 ┌──────┼───────┐             ┌────┴─────┐
 USER  HOME    PATH          crontab   /etc/cron.d
  │      │       │              │           │
  └──────┴───────┘              └─────┬─────┘
          │                            │
      Bash scripts               scheduled jobs
          │                            │
     $(command)                       │
          │                            │
    dynamic paths              automatic execution
          │                            │
          └────────────┬───────────────┘
                       │
                  Verification
                       │
             ┌─────────┼─────────┐
             │         │         │
            ps       pstree    cat/ls
             │
          PID/PPID
             │
      process relationships
```

---

# 21. Short Memory Card

```text
env          → environment
env | sort   → readable environment
$USER        → current user
$HOME        → home directory
$PATH        → command search path
$$           → current shell PID
unset X      → remove variable
$(cmd)       → command output inside another command
chmod +x     → make executable
crontab -e   → edit user's cron jobs
crontab -l   → list user's cron jobs
/etc/cron.d  → system cron configuration
ps           → processes
ps -ef       → detailed processes
pstree       → process hierarchy
PID          → process ID
PPID         → parent process ID
```

---

# 22. What I Should Be Comfortable With Now

By this stage, I should be able to:

- Navigate Linux confidently.
- Create, edit, move, copy and delete files.
- Search through files efficiently.
- Chain commands using pipes.
- Redirect output and errors.
- Work with archives and compression.
- Inspect processes.
- Understand PID/PPID relationships.
- Inspect environment variables.
- Write basic dynamic Bash scripts.
- Make scripts executable.
- Understand personal vs system cron jobs.
- Investigate scheduled execution.
- Connect networking observations with Linux processes/services.
- Apply these skills to authorized CTF/lab environments.

---

# 23. Main Lesson of Day 036

> **Linux security is not just about knowing commands. It is about connecting evidence.**

A strong workflow is:

```text
Observe → Identify → Connect → Test → Verify → Explain
```

That mindset will matter more as the roadmap moves toward:

- deeper networking
- Bash automation/projects
- Python
- web security
- OSINT
- cryptography
- reverse engineering
- responsible disclosure
- CTF/hackathon-style problem solving

---

## Final Reflection

Today's work helped turn earlier Linux commands into a more connected mental model.

I am no longer only learning:

```bash
ps
grep
cat
crontab
env
```

individually.

I am learning how they can work together to answer a real question about a Linux system.

That is the foundation I need before moving into more advanced security work.
