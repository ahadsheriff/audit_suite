A Port scan will determine if a service is availible on a
remote machine. This utility is used to perform port scans 
on specified hosts.The connectivity of each port will be 
determined through the scan type "TCP Connect". The state 
of each port will be shown to be open if the connection 
succeds and closed if it fails.

Usage: [IP Address Range] -p [Port range]
Example: ./portscan.ps1 10.10.1.2-10.10.2.4 -p 144-455
