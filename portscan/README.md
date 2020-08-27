# Portscan

Scan all TCP and UDP ports from a host or a subnet.

## How it works

1. Scan all TCP and UDP ports with `masscan`
2. Filter the found ports of each protocol
3. Run `nmap` to enumerate the found TCP ports, if any
4. Run `nmap` to enumerate the found UDP ports, if any
5. Save the findings in the directory **./nmap**

The `nmap` scans run service discovery (`-sV`) and the default scripts (`-sC`).

The results are saved in normal text, grepable format, and XML format.

## Usage

```bash
portscan <ip/range> <interface> [filename]
```

- `interface`: interface/adapter to use
- `filename`: name of the output files (default: nmap)
