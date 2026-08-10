# Day 037 Notes — Bash File Auditing, Arguments, Loops & Security Automation

## Title
**Day 037 — Bash File Auditing, Arguments, Loops and Security Automation**

## Description
A structured revision note for Day 037 covering Bash script arguments, special variables, loops, file/path tests, permissions, conditional logic, command chaining, debugging, and how these concepts combine into practical security automation.

---

## 1. What I Learned Today

Today's main shift was from using individual Bash commands to **building a script that can inspect multiple targets automatically**.

The practical script worked with:

- `$USER`
- `$$`
- `$#`
- `$@`
- positional arguments such as `$1`
- `if` conditions
- `for` loops
- file/path tests
- permission tests
- counters
- `&&` and `||`
- exit status
- executable permissions
- debugging shell scripts

The overall idea:

> **Input → Validate → Iterate → Inspect → Classify → Report**

That pattern is extremely useful for security automation.

---

# 2. Bash Script Arguments

Arguments allow a script to receive information from the command line.

Example:

```bash
./audit.sh /etc/passwd /etc/hosts
```

Here:

```text
$1 = /etc/passwd
$2 = /etc/hosts
```

### Important argument variables

| Variable | Meaning |
|---|---|
| `$0` | Script name/path |
| `$1` | First argument |
| `$2` | Second argument |
| `$#` | Number of arguments |
| `$@` | All arguments, preserved as separate arguments when quoted |
| `$*` | All arguments treated as one expanded list in many common contexts |

### Most important rule

Use:

```bash
"$@"
```

when processing multiple command-line arguments.

Example:

```bash
for target in "$@"; do
    echo "Checking: $target"
done
```

This lets one script process many files/directories.

---

# 3. `$USER`

`$USER` contains the current username.

Example:

```bash
echo "$USER"
```

Possible output:

```text
sonu
```

### Why it matters

Security scripts often need to know **which account is executing the operation**.

Examples:

- audit ownership
- logging
- access checks
- identifying the executing user
- creating user-specific reports

---

# 4. `$$` — Current Shell PID

`$$` represents the process ID of the current shell/script.

Example:

```bash
echo "$$"
```

### Why it matters

A process ID can be useful when:

- debugging
- identifying a running script
- creating temporary filenames
- tracing processes
- investigating process relationships

Example:

```bash
log="/tmp/audit_$$.log"
```

The PID makes the temporary filename more unique.

---

# 5. `$#` — Number of Arguments

`$#` tells us how many arguments were supplied.

Example:

```bash
echo "$#"
```

If we execute:

```bash
./audit.sh file1 file2 file3
```

then:

```text
$# = 3
```

### Validation example

```bash
if [ "$#" -eq 0 ]; then
    echo "No file supplied."
    exit 1
fi
```

This prevents the script from running without required input.

---

# 6. `$@` — Processing Multiple Targets

`"$@"` expands into the arguments supplied to the script.

Example:

```bash
for target in "$@"; do
    echo "Inspecting: $target"
done
```

Running:

```bash
./audit.sh file1 file2 file3
```

causes the loop to process each target separately.

### Security relevance

This is the foundation of batch security tooling.

A future security script could inspect:

```text
/etc/passwd
/etc/shadow
/home/*
/var/log/*
```

or files discovered during an authorized assessment.

---

# 7. `if` Conditions

Bash uses `if` to make decisions.

Basic structure:

```bash
if [ condition ]; then
    command
fi
```

Example:

```bash
if [ -e "$target" ]; then
    echo "Path exists"
fi
```

The condition determines what the script does next.

---

# 8. File and Path Tests

These tests are extremely important for Bash automation.

### `-e`

Checks whether a path exists.

```bash
[ -e "$target" ]
```

### `-f`

Checks whether the path is a regular file.

```bash
[ -f "$target" ]
```

### `-d`

Checks whether the path is a directory.

```bash
[ -d "$target" ]
```

### `-r`

Checks whether the path is readable.

```bash
[ -r "$target" ]
```

### `-w`

Checks whether the path is writable.

```bash
[ -w "$target" ]
```

### `-x`

Checks whether the path is executable.

```bash
[ -x "$target" ]
```

### Mental model

```text
-e → exists?
-f → regular file?
-d → directory?
-r → readable?
-w → writable?
-x → executable?
```

These are worth memorizing.

---

# 9. File Classification

A useful audit script can first check:

```bash
if [ -f "$target" ]; then
    echo "Type: Regular file"
elif [ -d "$target" ]; then
    echo "Type: Directory"
else
    echo "Type: Other"
fi
```

This prevents treating every path as though it were the same type.

### Real-world use

A security scanner may need different logic for:

- files
- directories
- symbolic links
- devices
- sockets

Classification is therefore an important first step.

---

# 10. Permission Checking

We also learned to check permissions.

```bash
[ -r "$target" ]
[ -w "$target" ]
[ -x "$target" ]
```

Example:

```bash
[ -r "$target" ] && echo "Readable: Yes" || echo "Readable: No"
```

### Meaning of `&&`

The command after `&&` runs if the previous command succeeds.

```text
condition succeeds
        ↓
       &&
        ↓
   run command
```

### Meaning of `||`

The command after `||` runs when the previous command fails.

```text
condition fails
      ↓
     ||
      ↓
run alternative
```

Together:

```bash
condition && success_command || failure_command
```

can create compact conditional logic.

---

# 11. Counter Variables

The audit script used a counter:

```bash
count=0
```

Then:

```bash
count=$((count + 1))
```

This increments the value.

Example:

```bash
count=0

for target in "$@"; do
    if [ -e "$target" ]; then
        count=$((count + 1))
    fi
done

echo "Checked files: $count"
```

### Why counters matter

They allow scripts to produce useful summaries:

```text
Targets supplied: 5
Existing: 4
Missing: 1
Readable: 4
Writable: 2
Executable: 1
```

This is much more useful than printing raw command output.

---

# 12. `for` Loops

Basic structure:

```bash
for item in list; do
    commands
done
```

For command-line arguments:

```bash
for target in "$@"; do
    echo "$target"
done
```

### Why loops matter in cybersecurity

Without loops:

```text
check file1
check file2
check file3
check file4
...
```

With loops:

```bash
for target in "$@"; do
    check "$target"
done
```

One piece of logic can handle many targets.

---

# 13. `exit`

`exit` ends a script and can provide a status code.

Example:

```bash
exit 1
```

Usually:

```text
0 → success
non-zero → error/failure
```

Example:

```bash
if [ "$#" -eq 0 ]; then
    echo "No file supplied."
    exit 1
fi
```

This makes the script behave predictably when another program calls it.

---

# 14. `chmod +x`

A Bash script needs executable permission if we want to run it directly as:

```bash
./audit.sh
```

We can add it with:

```bash
chmod +x audit.sh
```

Then:

```bash
./audit.sh /etc/passwd
```

### Debugging lesson from today

A common error was:

```text
Permission denied
```

The first thing to check is:

```bash
ls -l audit.sh
```

If executable permission is missing:

```bash
chmod +x audit.sh
```

Then try again.

---

# 15. `"$user"` vs `$user`

Quoting variables is an important Bash habit.

Prefer:

```bash
echo "$USER"
```

rather than relying on unquoted expansion.

Why?

Quoting protects values containing spaces or special characters from being split or interpreted unexpectedly.

General rule:

> **Quote variables unless you deliberately need word splitting or glob expansion.**

---

# 16. Globbing

Bash supports patterns such as:

```bash
/tmp/*_lab.txt
```

This can match files such as:

```text
/tmp/sonu_lab.txt
/tmp/test_lab.txt
```

Globbing is performed by the shell before the command receives the arguments.

### Important distinction

Globbing:

```bash
*.txt
```

is not the same thing as a regular expression.

Keep these concepts separate.

---

# 17. Command Substitution

We used:

```bash
$(whoami)
```

Example:

```bash
cat /tmp/$(whoami)_lab.txt
```

The shell executes:

```bash
whoami
```

and substitutes its output into the command.

If:

```text
whoami → sonu
```

then the command effectively becomes:

```bash
cat /tmp/sonu_lab.txt
```

### Real-world use

Command substitution is useful when scripts need dynamic information:

```bash
$(date)
$(whoami)
$(hostname)
$(pwd)
```

---

# 18. Environment Variables

We previously learned:

```bash
env
```

and:

```bash
printenv
```

These display environment variables.

Examples:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
echo "$SHELL"
```

### Important variables

| Variable | Meaning |
|---|---|
| `$USER` | Current user |
| `$HOME` | User's home directory |
| `$PWD` | Current directory |
| `$SHELL` | Current/default shell |
| `$PATH` | Command search path |
| `$HOSTNAME` | Host/system name |
| `$TERM` | Terminal type |

---

# 19. `unset`

`unset` removes a shell variable.

Example:

```bash
NAME="sonu"
echo "$NAME"

unset NAME

echo "$NAME"
```

After `unset`, the variable is no longer defined in that shell environment.

### Security relevance

Understanding environment variables matters because programs can inherit environment information.

It is important when studying:

- shell behavior
- configuration
- process environments
- command execution
- security misconfiguration

---

# 20. Process Concepts Already Learned

Today's Bash work connects strongly with earlier process learning.

Important commands:

```bash
ps
ps -ef
ps aux
pstree
pgrep
```

### `ps`

Shows processes associated with the current terminal/session.

### `ps -ef`

Provides a broader process listing including:

- UID
- PID
- PPID
- start time
- command

### `pstree`

Shows parent-child relationships.

Example mental model:

```text
init
 ├── login
 │    └── bash
 │         └── script
 └── cron
      └── scheduled task
```

This is useful for understanding how processes are launched.

---

# 21. Cron / Scheduled Tasks

We previously studied:

```bash
crontab -e
crontab -l
```

and system cron locations such as:

```text
/etc/crontab
/etc/cron.d/
```

Cron allows commands/scripts to execute automatically according to a schedule.

General structure:

```text
minute hour day month weekday command
```

Example concept:

```text
0 2 * * * /path/to/script.sh
```

means a task scheduled around 2:00 every day.

### Security relevance

Cron matters for:

- automated backups
- monitoring
- log collection
- maintenance
- authorized security auditing
- understanding scheduled execution
- investigating suspicious scheduled tasks

---

# 22. Networking Concepts Previously Learned

The networking foundation should remain part of revision.

Important commands/concepts:

```bash
ip addr
ip link
ip route
ping
ss -tuln
```

### `ip addr`

Shows interfaces and IP addresses.

### `ip link`

Shows network interfaces and link state.

### `ip route`

Shows routing information.

### `ping`

Tests reachability using ICMP echo requests.

### `ss -tuln`

Helps inspect listening TCP/UDP sockets.

### Security mental model

When investigating a machine:

```text
Who am I?
   ↓
What machine am I on?
   ↓
What network interfaces exist?
   ↓
What addresses are assigned?
   ↓
Where does traffic route?
   ↓
What services are listening?
   ↓
Which processes own those services?
```

This connects Linux, processes and networking into one investigation workflow.

---

# 23. Debugging Rules to Remember

Today's work reinforces a very important habit:

> **Do not assume the command is wrong before checking the exact error.**

### Step 1 — Read the error

Examples:

```text
Permission denied
No such file or directory
command not found
syntax error
```

Each indicates a different category of problem.

### Step 2 — Check the file

```bash
ls -l script.sh
```

### Step 3 — Check the path

```bash
pwd
ls
```

### Step 4 — Check permissions

```bash
ls -l script.sh
```

### Step 5 — Check syntax

```bash
bash -n script.sh
```

### Step 6 — Trace execution when necessary

```bash
bash -x script.sh
```

This shows commands as Bash executes them.

### Step 7 — Test small pieces

Do not debug a 100-line script all at once.

Test:

```bash
echo "$USER"
echo "$#"
echo "$@"
```

then the condition, then the loop, then the counter.

---

# 24. Security Thinking Pattern

The most important conceptual progression is:

### Level 1 — Command

```bash
ls
```

### Level 2 — Command with data

```bash
ls "$HOME"
```

### Level 3 — Condition

```bash
if [ -e "$file" ]; then
```

### Level 4 — Repetition

```bash
for file in "$@"; do
```

### Level 5 — Automation

```text
input
 ↓
validate
 ↓
iterate
 ↓
inspect
 ↓
classify
 ↓
record
 ↓
report
```

This is the beginning of writing actual security utilities rather than simply using Linux commands manually.

---

# 25. Real-Life Security Uses

These concepts can eventually be combined into authorized tools for:

### File auditing

Check:

- ownership
- permissions
- file types
- suspicious locations

### Configuration auditing

Inspect configuration files for expected settings.

### Log analysis

Loop through log files and search for patterns.

### Permission auditing

Find files that are unexpectedly writable or executable.

### System inventory

Collect:

- user
- hostname
- interfaces
- routes
- listening services
- running processes

### Scheduled-task auditing

Inspect cron configuration to understand what executes automatically.

---

# 26. Professor Questions — Answers

### Q1. Why use `"$@"` instead of `$@`?

`"$@"` preserves each supplied argument as a separate argument, making it safer for filenames or paths containing spaces.

### Q2. What is `$#`?

It is the number of command-line arguments supplied to the script.

### Q3. What is the difference between `$0` and `$1`?

`$0` normally represents the script name/path, while `$1` is the first user-supplied argument.

### Q4. Why check `$#` before processing?

To validate that the user supplied the required input and prevent incorrect execution.

### Q5. Why use `-e`, `-f`, and `-d`?

They distinguish whether a path exists, is a regular file, or is a directory.

### Q6. Why check `-r`, `-w`, and `-x`?

They determine whether the current user/process can read, write, or execute the target.

### Q7. Why use a `for` loop?

To apply the same operation to multiple targets without duplicating code.

### Q8. What does `&&` mean?

Run the next command if the previous command succeeds.

### Q9. What does `||` mean?

Run the next command if the previous command fails.

### Q10. Why use `exit 1`?

To stop execution and communicate a failure/non-success status.

### Q11. Why did `Permission denied` occur?

The script did not have the required executable permission for direct execution. A typical fix is:

```bash
chmod +x audit.sh
```

followed by:

```bash
./audit.sh ...
```

### Q12. Why is quoting important?

It prevents unwanted word splitting and expansion when variables contain spaces or special characters.

---

# 27. Quick Revision Flashcard

```text
$0       → script name
$1       → first argument
$#       → argument count
$@       → all arguments
$$       → current shell PID

-e       → exists
-f       → regular file
-d       → directory
-r       → readable
-w       → writable
-x       → executable

&&       → if success
||       → if failure

for      → repeat over targets
if       → decision
exit 0   → success
exit 1   → failure

$(...)   → command substitution

chmod +x → make script executable

env      → environment
printenv → environment
unset X  → remove variable X

ps       → processes
ps -ef   → detailed process list
pstree   → process hierarchy

crontab -e → edit user cron
crontab -l → list user cron

ip addr  → addresses
ip link  → interfaces
ip route → routing
ping     → ICMP reachability
ss -tuln → listening sockets
```

---

# 28. What I Should Be Able to Do Now

By the end of this stage I should be able to:

- accept multiple files as script arguments
- validate input
- loop over targets
- identify files/directories
- check permissions
- maintain counters
- generate simple reports
- understand environment variables
- understand process relationships
- inspect cron configuration
- connect processes with network services
- debug permission and path problems
- turn repeated commands into automation

---

# 29. Next Step

The next major progression should be **larger Bash automation**, rather than repeatedly learning isolated commands.

The Bash project should combine:

```text
Arguments
   +
Conditions
   +
Loops
   +
File tests
   +
Permissions
   +
Process inspection
   +
Networking information
   +
Logging
   +
Reporting
```

The goal is to produce a small, clean **authorized Linux security-audit utility** that demonstrates actual understanding rather than just command memorization.

---

## Day 037 Core Lesson

> **A security professional does not just know commands. They know how to combine commands into reliable, repeatable investigations.**

Today's Bash concepts are the bridge between Linux fundamentals and security automation.
