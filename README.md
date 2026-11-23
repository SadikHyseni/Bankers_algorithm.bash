# Banker's Algorithm (Bash)

A Bash script that runs the **Banker's Algorithm**, the deadlock-avoidance algorithm used in operating systems. It checks whether a system is in a safe state and whether a process's resource request can be granted safely.

## How It Works

1. You enter the number of processes and resource types.
2. You enter the **Allocation** matrix (resources each process holds now).
3. You enter the **Max** matrix (the most each process may need).
4. The script calculates **Need = Max − Allocation**.
5. You enter the **Available** resources.
6. The script runs the **safety check** to see if every process can finish in some order.
7. You enter a resource request from one process. The script checks that it's valid, pretends to grant it, and runs the safety check again.

## Requirements

- Bash 4.0 or later (the script uses associative arrays)
- Linux, macOS (with an updated Bash) or WSL on Windows

## Usage

```bash
chmod +x bankers_algorithn.bash
./bankers_algorithn.bash
```

## Example

The standard textbook example with 5 processes and 3 resource types:

| Process | Allocation | Max | Need |
|---------|------------|-----|------|
| P0 | 0 1 0 | 7 5 3 | 7 4 3 |
| P1 | 2 0 0 | 3 2 2 | 1 2 2 |
| P2 | 3 0 2 | 9 0 2 | 6 0 0 |
| P3 | 2 1 1 | 2 2 2 | 0 1 1 |
| P4 | 0 0 2 | 4 3 3 | 4 3 1 |

**Available:** 3 3 2

When P1 requests `1 0 2`, the output is:

```
System is in a safe state.
System is in a safe state.
Request can be granted. System remains in a safe state.
```

## Output Messages

| Message | Meaning |
|---------|---------|
| `System is in a safe state.` | Every process can finish without deadlock |
| `System is not in a safe state.` | A deadlock could happen |
| `Invalid request. Request exceeds maximum or available resources.` | The request is more than the process needs or more than is available |
| `Request can be granted. System remains in a safe state.` | The request is safe to grant |

## License

MIT License. See [LICENSE](LICENSE).
