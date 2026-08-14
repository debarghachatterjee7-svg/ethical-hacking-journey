# Notes 044 — Cryptographic Hashing Fundamentals

> **Title:** Notes 044 — Cryptographic Hashing, MD5, SHA-256 & File Integrity  
> **Description:** Permanent revision notes for Day 41. Designed for long-term recall rather than command memorization.

## 1. Core Mental Model

```text
DATA
 ↓
HASH FUNCTION
 ↓
FIXED-SIZE DIGEST
```

Memory phrase:

> **Hash = mathematical fingerprint of data**

A hash is not literally unique. Collisions are mathematically possible because many possible inputs map into a finite output space.

## 2. Hashing vs Encryption

### Hashing
- One-way transformation
- Fixed-size digest
- Useful for integrity and cryptographic constructions
- Not a substitute for encryption

### Encryption
- Designed to be reversible with the appropriate key
- Primarily used for confidentiality

Memory phrase:

> **Encryption hides. Hashing fingerprints.**

## 3. Cryptographic Hash Properties

### Deterministic
Same input + same algorithm → same output.

### Fixed length
The digest size depends on the algorithm.

### Avalanche effect
Small input change → drastically different-looking output.

### Preimage resistance
Given a hash, finding a corresponding input should be computationally difficult.

### Second-preimage resistance
Given an input, finding another input with the same hash should be difficult.

### Collision resistance
Finding any two different inputs with the same hash should be difficult.

## 4. Collision

```text
A ≠ B
but
Hash(A) = Hash(B)
```

Collisions must exist in principle for finite-output hash functions with larger input spaces. Security comes from making useful collisions difficult to find.

## 5. MD5

Full name:

**Message-Digest Algorithm 5**

Output:

**128 bits**

Hexadecimal length:

```text
128 ÷ 4 = 32
```

Therefore:

**MD5 = 32 hexadecimal characters**

Example:

```text
5d41402abc4b2a76b9719d911017c592
```

## 6. MD5 Security

MD5 has practical collision attacks and is cryptographically broken for modern security-critical applications.

Do not choose MD5 for new cryptographic designs.

It remains useful to understand because it appears in:
- Legacy systems
- Older software
- CTFs
- Old datasets
- File-identification contexts

## 7. Linux Commands

Hash a file:

```bash
md5sum file.txt
```

Hash text:

```bash
echo -n "hello" | md5sum
```

SHA-256:

```bash
sha256sum file.txt
```

## 8. Why `-n` Matters

```bash
echo "hello"
```

normally includes a newline.

```bash
echo -n "hello"
```

does not.

Therefore these can hash different byte sequences:

```text
hello
hello

```

Important memory:

> **Hash functions process bytes, not human intention.**

## 9. File Integrity

```text
FILE
 ↓
HASH
 ↓
REFERENCE CHECKSUM

Later:
FILE
 ↓
HASH
 ↓
COMPARE
```

If the values differ, the data changed or the inputs/process differed.

Important limitation:

A checksum alone does not prove authenticity if an attacker can replace both the file and the checksum.

## 10. MD5 vs SHA-256

| Algorithm | Bits | Hex Characters | Security Summary |
|---|---:|---:|---|
| MD5 | 128 | 32 | Broken for cryptographic collision resistance |
| SHA-1 | 160 | 40 | Deprecated/broken for collision resistance |
| SHA-256 | 256 | 64 | Widely used modern cryptographic hash |

## 11. Password Security Connection

Do not think:

```text
password → MD5 → secure
```

Attackers can guess passwords and hash their guesses.

Password storage should use dedicated password KDFs such as:
- Argon2
- bcrypt
- scrypt
- PBKDF2

Salts and correct system design are also required.

This will be studied later.

## 12. Common Mistakes

### Mistake: treating text as a filename

```bash
md5sum hello
```

means a file named `hello`.

For text:

```bash
echo -n "hello" | md5sum
```

### Mistake: thinking MD5 is encryption

It is not.

### Mistake: thinking one-way means impossible to guess

Attackers can test guesses.

### Mistake: thinking a matching checksum proves authenticity

Only if the reference checksum itself is trusted/authenticated.

## 13. Memory Anchors

### Hash
**DATA → FIXED FINGERPRINT**

### MD5
**128 bits → 32 hex characters → broken for modern cryptographic security**

### SHA-256
**256 bits → 64 hex characters → widely used**

### Avalanche
**Tiny change → big-looking output change**

### Collision
**Different inputs → same output**

## 14. Future Connections

```text
HASHING
 ↓
PASSWORD SECURITY
 ↓
SALTS
 ↓
PASSWORD KDFs
 ↓
HMAC
 ↓
DIGITAL SIGNATURES
 ↓
CERTIFICATES
 ↓
TLS
```

Today's hashing lesson is foundational to later cybersecurity topics.

## 15. Active Recall

Close the notes and answer:
1. What is hashing?
2. Hashing vs encryption?
3. MD5 output size?
4. MD5 hex length?
5. What is a collision?
6. What is avalanche effect?
7. Why does `echo -n` matter?
8. Why is MD5 broken?
9. Can attackers guess hashed passwords?
10. Why isn't SHA-256 alone a password-storage solution?

## Final Memory Sentence

> A cryptographic hash converts data into a fixed-size digest. The same input gives the same digest, while a small input change should produce a drastically different-looking digest. MD5 produces 128 bits / 32 hex characters, but its collision resistance is broken, so it should not be used for modern security-critical cryptography.
