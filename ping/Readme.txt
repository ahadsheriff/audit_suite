The pingnetwork.ps1 is a network discovery tool using PowerShell. This script takes a command line argument which represents the range of IPs that the utility should sweep. This can either be in cider notation, or in a range format. This script will print the successful ICMP requests.

Usage:
    .\pingnetwork.ps1 10.0.0.0/24
    .\pingnetwork.ps1 10.0.0.0-10.0.0.12
