import subprocess
import os

ip_file = open("ip.txt","r")
ip = ip_file.readlines()
os.system("echo '\n' > pingResults.txt")

up_ips = []
ttls = []

def ping():
    for address in ip:
        address = address.strip()
        command = "ping -c 1 {} >> pingResults.txt".format(address)
        os.system(command)
	
    ip_file.close()

def starts():
    counter = 0
    ipLine = []
    with open("pingResults.txt", "r") as fi:
        id = []
        for ln in fi:
            if ln.startswith("64"):
                id.append(ln[2:])
                ipLine.append(id[counter])
                counter += 1
    for i in ipLine:
        words = i.split(" ")
        up_ips.append(words[3])
        ttls.append(words[5])

def finder():
    count = 0
    for i in ttls:
        addr = up_ips[count]
        time = ttls[count]
        if i == 'ttl=64' or i == 'ttl=61' or i == 'ttl=63':
            print(addr + " is a *nix device.\n")
            count += 1
        elif i == 'ttl==255' or i == 'ttl==254' or i == 'ttl==253':
            print(addr + " is a freeBSD device.\n")
            count += 1 
        else:
            print(addr + "is a Windows device.\n")
            count += 1

def main():
    ping()
    starts()
    finder()

if __name__ == '__main__':
    main()
