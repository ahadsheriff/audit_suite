To run the osclassify.py script, simply add a list of ip addresses (one per line) into the ip.txt file (included).

Then simply run the program like any other Python program:
    python3 osclassify.py

The program will ping each IP address one by one, and pipe the output to the "PingResults.txt" file.

Then the program will parse through the ping output and observe ping TTL's to determine the OS of the host.