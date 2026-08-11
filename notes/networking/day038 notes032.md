# NOTE032 --- Bash Functions, File Auditing & Debugging

## Today's Core Idea

Today's learning was about moving from **individual Bash commands** to
**structured automation**.

The key progression is:

``` text
Commands → Conditions → Loops → Arguments → Functions → Debugging → Automation
```

------------------------------------------------------------------------

# 1. Bash Functions

A function is reusable Bash logic.

``` bash
check_file() {
    local target="$1"
    ...
}
```

Call it with:

``` bash
check_file "/etc/passwd"
```

### Important points

-   Function name identifies the reusable block.
-   `$1`, `$2`, etc. are function arguments.
-   `local` limits a variable to the function.
-   `return 0` normally means success.
-   Non-zero return values indicate failure.

### Why functions matter

Instead of:

``` text
repeat the same code
repeat it again
repeat it again
```

we use:

``` text
write once
     ↓
call many times
```

This makes larger scripts maintainable.

------------------------------------------------------------------------

# 2. Function Arguments

Example:

``` bash
greet() {
    echo "Hello $1"
}

greet "Linux"
```

`$1` becomes `Linux`.

This is different from the script's positional arguments only in
**scope/context**.

------------------------------------------------------------------------

# 3. `"$@"`

`"$@"` represents all positional arguments individually.

Example:

``` bash
for target in "$@"; do
    echo "$target"
done
```

If:

``` bash
./script.sh file1 file2 file3
```

then the loop processes each target separately.

### Remember

Prefer:

``` bash
"$@"
```

when you want to preserve each argument as a separate item, especially
when paths contain spaces.

------------------------------------------------------------------------

# 4. File Tests

## Existence

``` bash
[ -e "$target" ]
```

Checks whether the path exists.

## Regular file

``` bash
[ -f "$target" ]
```

Checks for a regular file.

## Directory

``` bash
[ -d "$target" ]
```

Checks for a directory.

------------------------------------------------------------------------

# 5. Permission Tests

``` bash
[ -r "$target" ]
```

Readable.

``` bash
[ -w "$target" ]
```

Writable.

``` bash
[ -x "$target" ]
```

Executable/searchable depending on the target type and context.

### Mental model

``` text
-e → exists?
-f → regular file?
-d → directory?
-r → readable?
-w → writable?
-x → executable?
```

These tests are extremely useful in system auditing.

------------------------------------------------------------------------

# 6. Conditional Logic

Basic structure:

``` bash
if condition; then
    commands
elif another_condition; then
    commands
else
    commands
fi
```

### Important debugging rule

Always check the matching structure:

``` text
if → fi
for → done
case → esac
```

A missing closing keyword can cause errors much later than the actual
mistake.

------------------------------------------------------------------------

# 7. Loops

Today's audit script used:

``` bash
for target in "$@"; do
    ...
done
```

This means:

> Take each supplied argument and process it.

This is ideal for automation.

------------------------------------------------------------------------

# 8. Arithmetic Expansion

Counters used:

``` bash
existing_count=0
missing_count=0
```

Then:

``` bash
existing_count=$((existing_count + 1))
```

This is Bash arithmetic expansion.

It allows scripts to maintain state and produce summaries.

------------------------------------------------------------------------

# 9. Exit Status

``` bash
echo $?
```

prints the previous command's exit status.

Convention:

``` text
0       success
non-zero failure
```

Functions can therefore be used as tests:

``` bash
if check_file "$target"; then
    echo "Valid"
fi
```

------------------------------------------------------------------------

# 10. Debugging Bash

## Syntax-only check

``` bash
bash -n script.sh
```

Use this first when Bash reports a syntax problem.

## Execution tracing

``` bash
bash -x script.sh
```

Use this when the script is syntactically valid but behaves incorrectly.

### Debugging hierarchy

``` text
Syntax error?
    ↓
bash -n
    ↓
Still behaving incorrectly?
    ↓
bash -x
    ↓
Inspect variables / conditions / loop flow
```

------------------------------------------------------------------------

# 11. Today's Actual Debugging Lessons

### Permission problem

The script initially returned:

``` text
Permission denied
```

The solution was:

``` bash
chmod +x script.sh
```

Lesson:

> Not every script failure is a coding error.

Check:

-   permissions
-   path
-   interpreter
-   syntax
-   arguments
-   runtime behavior

------------------------------------------------------------------------

### Syntax problem

`lab4.sh` initially produced errors around `else` and `done`.

The root issue was the structure of the conditional/loop.

Correct mental structure:

``` bash
for ...; do
    if ...; then
        ...
    else
        ...
    fi
done
```

------------------------------------------------------------------------

# 12. Revision --- Bash Functions and Subparts

  Concept      What to remember
  ------------ ---------------------------------------
  Function     Reusable block of Bash commands
  `name()`     Function declaration
  `$1`         First function argument
  `$2`         Second function argument
  `"$@"`       All positional arguments individually
  `local`      Function-scoped variable
  `return 0`   Successful status
  `return 1`   Failure/non-success status
  `$?`         Previous command's exit status
  `if`         Conditional decision
  `elif`       Additional condition
  `else`       Fallback
  `fi`         Ends `if`
  `for`        Repetition
  `do`         Starts loop body
  `done`       Ends loop
  `-e`         Exists
  `-f`         Regular file
  `-d`         Directory
  `-r`         Readable
  `-w`         Writable
  `-x`         Executable/searchable
  `$((...))`   Arithmetic expansion
  `bash -n`    Syntax check
  `bash -x`    Execution tracing
  `chmod +x`   Add execute permission

------------------------------------------------------------------------

# 13. Broader Revision From Earlier Learning

## Basic navigation

``` bash
pwd
cd
ls
```

Purpose:

``` text
pwd → current directory
cd  → change directory
ls  → list contents
```

------------------------------------------------------------------------

## File operations

``` bash
cp
mv
rm
mkdir
touch
```

Remember the difference:

``` text
cp → copy
mv → move/rename
rm → remove
mkdir → create directory
touch → create/update file timestamp
```

------------------------------------------------------------------------

## Reading/searching

``` bash
cat
head
tail
grep
wc
find
sort
uniq
```

Mental model:

``` text
find → locate
grep → search content
sort → order lines
uniq → remove adjacent duplicates
wc → count
head → beginning
tail → end
cat → display/concatenate
```

------------------------------------------------------------------------

## Pipelines and redirection

``` bash
command1 | command2
```

means output of command 1 becomes input to command 2.

Examples:

``` bash
ps -ef | grep cron
```

Redirection:

``` bash
command > file
command >> file
command 2> file
```

Remember:

``` text
>   overwrite stdout
>>  append stdout
2>  redirect stderr
|   pipe stdout to another command
```

------------------------------------------------------------------------

# 14. Variables and Environment

Previously learned:

``` bash
echo "$USER"
echo "$HOME"
echo "$PATH"
env
printenv
export NAME=value
unset NAME
```

### Important distinction

Shell variable:

``` bash
NAME=value
```

Environment variable exported to child processes:

``` bash
export NAME=value
```

Remove variable:

``` bash
unset NAME
```

This becomes important when scripts depend on their execution
environment.

------------------------------------------------------------------------

# 15. Process and System Revision

Previously learned:

``` bash
ps
ps -ef
ps -aux
pstree
```

Mental model:

``` text
ps      → current/relevant processes
ps -ef  → detailed process listing
ps -aux → detailed process/resource-oriented view
pstree  → parent-child process relationships
```

------------------------------------------------------------------------

# 16. Networking Revision

Previously learned:

``` bash
ip link
ip addr
ip route
ss -tuln
ping
```

Mental model:

``` text
ip link   → interfaces/link state
ip addr   → IP addresses
ip route  → routing table
ss        → sockets/listening services
ping      → connectivity/reachability test
```

These commands are useful because a security professional needs to
understand what machine/network state actually looks like before
investigating it.

------------------------------------------------------------------------

# 17. Scheduled Tasks Revision

Previously learned:

``` bash
cron
crontab -e
crontab -l
/etc/cron.d/
```

Mental model:

``` text
cron
 ↓
scheduled execution
 ↓
script/command
 ↓
system action
```

This is useful for understanding Linux automation and scheduled jobs.

------------------------------------------------------------------------

# 18. How to Think Like a Debugger

When something fails, don't immediately rewrite everything.

Use:

``` text
1. Read the exact error.
2. Identify whether it is permission, syntax, input, path or runtime related.
3. Reproduce the problem.
4. Reduce it to the smallest failing part.
5. Test the assumption.
6. Fix one thing.
7. Run again.
8. Confirm the result.
```

### Most important rule

**The error message is evidence.**

Don't treat it as noise.

For example:

``` text
Permission denied
```

should make you think:

``` text
permissions → chmod → ls -l
```

A syntax error around `done` should make you inspect:

``` text
for → do → body → done
```

------------------------------------------------------------------------

# 19. Real-Life Use

Today's knowledge can eventually support tools such as:

### Permission auditor

``` text
Find → inspect → classify → report
```

### Configuration checker

``` text
Check configuration file
       ↓
Check existence
       ↓
Check permissions
       ↓
Report
```

### Log analyzer

``` text
Read logs
 ↓
grep
 ↓
count
 ↓
sort
 ↓
summarize
```

### Security automation

``` text
collect information
       ↓
run checks
       ↓
identify findings
       ↓
produce report
```

The goal is not simply to know commands. The goal is to recognize
**patterns that can be automated**.

------------------------------------------------------------------------

# 20. Today's Mind Map

``` text
                    BASH AUTOMATION
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
     Functions         Conditions         Loops
        │                 │                 │
     $1/$2/$@         if/elif/else       for/do/done
        │                 │                 │
      local             -e/-f/-d          "$@"
        │               -r/-w/-x             │
      return                                 │
        └─────────────────┬─────────────────┘
                          │
                       Counters
                          │
                       Reports
                          │
                      Debugging
                    ┌─────┴─────┐
                  bash -n     bash -x
                    │             │
                  syntax       execution
                          │
                       AUTOMATION
```

------------------------------------------------------------------------

# 21. What I Should Be Able to Do Now

After Day 038, you should be able to look at a task and think:

> "I can accept several targets, process each one, run checks through
> functions, maintain counters, handle errors, and produce a summary."

That is a much stronger skill than simply memorizing individual
commands.

------------------------------------------------------------------------

# 22. Future Direction

The next stage is to make scripts more robust through:

-   better input validation
-   cleaner functions
-   error handling
-   command-line options
-   logging
-   structured output
-   safer scripting practices
-   eventually a complete Bash security-audit project

The project should be built from these pieces rather than copied as one
large script.
