This utility will conduct brute force attacks on machines with the ssh
service running. This utility will hopefully yield two key pieces of
information from the host: 1. Is the host configured with a lockout for
multiple retries? 2. Does the host have default/easy credentials? This utility accomplishes this through the use of three input files. The first file contains all the IP addresses of hosts to test. The second file contains all the usernames to be tested on the host and the third, passwords to try on the host. All these files should have one item per line.

This utility is dependent on the pexpect python module. The easiest way to install this dependency is through the use of:
  pip3 install pexpect

Once the dependency has been installed on the system the proper usage for this utility is:
  python3 ./SSHScan.py [IP address file] [Username file] [Password file]
