# Day040 Notes — Bash Automation: Arguments, Options, Functions & File Auditing

## Notes title
**Day040 Notes 033 — Bash File-Audit Automation & Command-Line Design**

## Purpose
These notes capture the theory behind today's Bash work and connect it to the Bash concepts already learned. The goal is not just to remember commands, but to understand how to combine them into a small security-oriented automation program.

---

# 1. The core model

Today's Bash program follows:

```text
INPUT
  ↓
VALIDATE
  ↓
PARSE OPTIONS
  ↓
PROCESS TARGETS
  ↓
CHECK FILESYSTEM STATE
  ↓
COUNT RESULTS
  ↓
REPORT
```

This pattern is extremely reusable.

---

# 2. Positional parameters

## `$0`

The script name/path.

```bash
echo "$0"
```

Useful for usage messages:

```bash
echo "Usage: $0 [options] target..."
```

## `$1`, `$2`, `$3`

Individual arguments.

```bash
./script.sh file1 file2
```

Then:

```text
$1 = file1
$2 = file2
```

## `$#`

Number of arguments.

```bash
echo "$#"
```

Useful for validation:

```bash
if [ "$#" -eq 0 ]; then
    echo "No targets supplied."
    exit 1
fi
```

## `$@`

All positional arguments.

The preferred multi-target pattern is:

```bash
for target in "$@"; do
    ...
done
```

### Remember

`"$@"` is especially important because it preserves each argument separately.

---

# 3. Exit status

Commands return an exit status.

Convention:

```text
0     success
non-0 failure/error
```

Example:

```bash
grep "root" /etc/passwd
echo $?
```

This is important when scripts need to decide whether an operation succeeded.

You also used:

```bash
exit 1
```

to stop a script after invalid input.

---

# 4. Conditional tests

Bash supports filesystem tests inside `[ ... ]`.

## Existence

```bash
[ -e "$target" ]
```

## Regular file

```bash
[ -f "$target" ]
```

## Directory

```bash
[ -d "$target" ]
```

## Read permission

```bash
[ -r "$target" ]
```

## Write permission

```bash
[ -w "$target" ]
```

## Execute permission

```bash
[ -x "$target" ]
```

These are particularly useful in defensive security scripts.

---

# 5. Functions

A function packages reusable logic.

Example:

```bash
audit_target() {
    local target="$1"

    ...
}
```

Call it with:

```bash
audit_target "$target"
```

### Why functions matter

Without functions, the same checks would have to be repeated for every target.

With a function:

```text
target 1 → audit_target
target 2 → audit_target
target 3 → audit_target
```

This is cleaner and easier to maintain.

---

# 6. `local`

Inside functions:

```bash
local target="$1"
```

creates a function-local variable.

This helps prevent accidental changes to variables outside the function.

For larger Bash projects, using `local` consistently makes debugging easier.

---

# 7. Arithmetic and counters

Bash supports arithmetic expansion:

```bash
count=$((count + 1))
```

Example:

```bash
count_regular=0

if [ -f "$target" ]; then
    count_regular=$((count_regular + 1))
fi
```

Counters let the script convert many individual observations into a final report.

---

# 8. Loops

Today's script uses a `for` loop.

```bash
for target in "$@"; do
    audit_target "$target"
done
```

This is ideal when the number of inputs is unknown.

If five targets are supplied, the loop runs five times.

If twenty targets are supplied, it runs twenty times.

---

# 9. Short-circuit operators

Bash supports:

```bash
command1 && command2
```

Meaning:

> Run command2 only if command1 succeeds.

And:

```bash
command1 || command2
```

Meaning:

> Run command2 if command1 fails.

This is useful for compact permission reporting.

Example:

```bash
[ -r "$target" ] && echo "Readable: Yes" || echo "Readable: No"
```

---

# 10. Command substitution

You have already used command substitution in earlier work.

```bash
$(command)
```

Example:

```bash
user=$(whoami)
```

or:

```bash
file="/tmp/$(whoami)_lab.txt"
```

The command runs first and its output becomes part of the surrounding command.

This is extremely useful for dynamic filenames and automation.

---

# 11. Environment variables

Important variables already encountered include:

```bash
$USER
$HOME
$PATH
$PWD
$SHELL
```

Examples:

```bash
echo "$USER"
echo "$HOME"
echo "$PATH"
```

### Why `$PATH` matters

When you type:

```bash
ls
```

the shell searches directories listed in `$PATH` to find the executable.

Check:

```bash
echo "$PATH"
```

Find a command:

```bash
which ls
```

or:

```bash
command -v ls
```

---

# 12. `env` and `printenv`

Earlier work included:

```bash
env
```

which displays environment variables.

You also used:

```bash
printenv
printenv HOME
printenv PATH
printenv USER
```

Difference:

```text
env       → display environment / run command with modified environment
printenv  → display environment variables
```

---

# 13. `unset`

You also learned:

```bash
unset NAME
```

It removes a shell variable.

Example:

```bash
NAME="sonu"
echo "$NAME"

unset NAME
echo "$NAME"
```

After `unset`, the variable is no longer defined in that shell context.

Important: `unset` does not permanently delete a system setting or file. It removes a shell variable from the current shell environment.

---

# 14. Quoting

Use:

```bash
"$variable"
```

instead of:

```bash
$variable
```

especially for paths and user input.

Example:

```bash
target="/home/user/My Files/test.txt"
```

Correct:

```bash
cat "$target"
```

Quoting prevents word splitting and many argument-parsing bugs.

---

# 15. Option handling

A command-line program often supports options:

```text
-h → help
-v → verbose
-s → summary
```

A standard Bash approach is:

```bash
while getopts "hvs" opt; do
    case "$opt" in
        h) ... ;;
        v) ... ;;
        s) ... ;;
        *) ... ;;
    esac
done
```

`getopts` is preferable to manually trying to interpret every argument because it gives a consistent option-parsing structure.

---

# 16. `case`

`case` is useful when one value can have several possible meanings.

Conceptually:

```bash
case "$mode" in
    summary)
        ...
        ;;
    verbose)
        ...
        ;;
    *)
        ...
        ;;
esac
```

It is often easier to read than many nested `if` statements.

---

# 17. Cron connection

Previous work covered cron and crontab.

A manual audit:

```bash
./script.sh /etc/passwd /etc/hosts
```

can eventually become scheduled automation.

For example, a properly designed defensive audit could be scheduled periodically through a crontab entry.

Important principle:

```text
Manual audit → tested script → scheduled automation
```

Do not schedule a script until it has been tested carefully.

---

# 18. Process and system context

Previous work also covered:

```bash
ps
ps -ef
ps aux
pstree
```

These help understand what is running.

Useful combination:

```bash
ps -ef
pstree
```

This teaches the relationship between processes and parent processes.

The security connection is important:

```text
filesystem state
+
process state
+
network state
=
better system understanding
```

---

# 19. Networking connection

Earlier networking commands included:

```bash
ip addr
ip link
ip route
ss -tuln
ping
```

Their basic roles:

| Command | Main use |
|---|---|
| `ip addr` | IP addresses/interfaces |
| `ip link` | interface/link state |
| `ip route` | routing table |
| `ss -tuln` | listening TCP/UDP sockets |
| `ping` | basic reachability/latency test |

The larger lesson is that Bash automation can combine filesystem, process, and network information into one diagnostic report.

---

# 20. Debugging checklist

When a Bash program breaks, use this order.

### 1. Syntax

```bash
bash -n script.sh
```

### 2. Execution trace

```bash
bash -x script.sh ...
```

### 3. Permissions

```bash
ls -l script.sh
```

### 4. Interpreter

Check:

```bash
head -n 1 script.sh
```

Expected:

```bash
#!/bin/bash
```

### 5. Variables

Temporarily print values:

```bash
echo "target=$target"
echo "count=$count"
```

### 6. Quoting

Check every variable used as a path:

```bash
"$target"
```

### 7. Conditions

Verify spaces:

```bash
[ -e "$target" ]
```

### 8. Loops

Make sure:

```bash
for ...; do
    ...
done
```

has matching structure.

---

# 21. Security mindset

When building defensive automation, ask:

1. What is my input?
2. Can the input be empty?
3. Can the input contain spaces?
4. Can the target not exist?
5. What type of object is it?
6. What permissions does it have?
7. What should happen if a command fails?
8. How will I summarize the results?
9. Can the script be safely repeated?
10. Can the output be logged?

This is more important than memorizing syntax.

---

# 22. Revision — Bash functions and subparts learned so far

## `echo`

```bash
echo "text"
```

Prints output.

Useful for messages, debugging, and reports.

## `cat`

```bash
cat file
```

Displays file contents.

## `head`

```bash
head file
head -n 10 file
```

Shows the beginning of a file.

## `tail`

```bash
tail file
tail -n 10 file
```

Shows the end.

## `grep`

```bash
grep "pattern" file
```

Searches text.

Useful with pipelines:

```bash
ps -ef | grep cron
```

## `wc`

```bash
wc -l file
```

Counts lines.

## `sort`

```bash
sort file
```

Sorts lines.

## `uniq`

```bash
uniq
uniq -c
```

Removes adjacent duplicates / counts adjacent occurrences.

Often paired with:

```bash
sort file | uniq -c
```

## `find`

```bash
find /path -name "*.txt"
```

Searches filesystem objects.

## `chmod`

```bash
chmod +x script.sh
```

Changes permissions.

Common concepts:

```text
r = read
w = write
x = execute
```

## `pwd`

```bash
pwd
```

Prints current directory.

## `cd`

```bash
cd /path
cd ..
cd ~
```

Changes directory.

## `ls`

```bash
ls
ls -l
ls -la
```

Lists directory contents.

## `cp`

```bash
cp source destination
```

Copies files.

## `mv`

```bash
mv source destination
```

Moves or renames.

## `rm`

```bash
rm file
```

Removes files.

Use carefully.

## `file`

```bash
file target
```

Identifies file type.

## `which`

```bash
which command
```

Shows a command's resolved executable location when available.

## `command -v`

```bash
command -v command
```

Portable shell-friendly command lookup.

## `env`

```bash
env
```

Shows environment variables.

## `printenv`

```bash
printenv PATH
```

Shows environment values.

## `unset`

```bash
unset NAME
```

Removes a shell variable.

## `ps`

```bash
ps
ps -ef
ps aux
```

Shows processes.

## `pstree`

```bash
pstree
```

Shows parent/child process relationships.

## `ss`

```bash
ss -tuln
```

Shows listening TCP/UDP sockets.

## `ip`

```bash
ip addr
ip link
ip route
```

Shows interface, address, and routing information.

## `ping`

```bash
ping 127.0.0.1
ping example.com
```

Tests basic network reachability and reports latency.

## `cron` / `crontab`

```bash
crontab -e
crontab -l
```

Used for scheduled jobs.

System cron locations may include:

```text
/etc/crontab
/etc/cron.d/
/etc/cron.daily/
/etc/cron.hourly/
```

---

# 23. Mental map of the learning so far

```text
Linux
├── Filesystem
│   ├── ls
│   ├── cd
│   ├── pwd
│   ├── cp
│   ├── mv
│   ├── rm
│   ├── cat
│   ├── head
│   ├── tail
│   ├── find
│   └── file
│
├── Text processing
│   ├── grep
│   ├── sort
│   ├── uniq
│   ├── wc
│   └── pipes / redirection
│
├── Shell
│   ├── variables
│   ├── $USER
│   ├── $HOME
│   ├── $PATH
│   ├── $PWD
│   ├── $#
│   ├── $@
│   ├── $0 / $1...
│   ├── command substitution
│   └── unset
│
├── Bash programming
│   ├── if
│   ├── test operators
│   ├── functions
│   ├── for loops
│   ├── case
│   ├── getopts
│   ├── arithmetic
│   └── exit status
│
├── Permissions
│   ├── r
│   ├── w
│   ├── x
│   └── chmod
│
├── Processes
│   ├── ps
│   ├── ps -ef
│   ├── ps aux
│   └── pstree
│
├── Scheduling
│   ├── cron
│   ├── crontab -e
│   └── crontab -l
│
└── Networking
    ├── ip addr
    ├── ip link
    ├── ip route
    ├── ss
    └── ping
```

---

# 24. Real-life application

Today's concepts can eventually be combined into a defensive health-check utility:

```text
Check:
├── important files
├── permissions
├── running processes
├── listening services
├── network interfaces
├── routes
└── scheduled jobs

Then:
→ validate
→ collect
→ classify
→ count
→ report
→ optionally log
```

That is the bridge from individual Linux commands to actual security automation.

---

# 25. Key things to remember

- Quote variables.
- Validate input before processing it.
- Use functions for repeated logic.
- Use `"$@"` for arbitrary numbers of arguments.
- Keep counters initialized.
- Distinguish file, directory, and missing path.
- Understand `r`, `w`, and `x`.
- Check exit statuses when reliability matters.
- Use `bash -n` before executing a broken script.
- Use `bash -x` when you need to see what Bash is doing.
- Build small pieces first and combine them afterward.
