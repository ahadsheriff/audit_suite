#
# Contributors: Michael Boc, Ahad Sheriff, Christian Rispoli
# Date:         09/28/2017
# File:         pingnetwork.ps1
#
# This script reads a newline separated list of IP address, prints the # percentage of success, and prints out the IPs who did not respond.
#


# global variable for the range sweep, please fogive my bad practice
$Global:stopIP = $null


# this function is a patch of the resursive ping sweep, without this function 
# would be impossible to set a range of IPs for the utility to ping. This 
# function compares two arrays to see if their values are equal in each index.
#
# params array1    the first array being tested 
# params array2    the second array being tested
function recursive_patch([int[]]$array1, [int[]]$array2){

    # compares each value in the array for equality
    for($i=0;$i -lt 4; $i++){
        if ($array1[$i] -ne $array2[$i]){
            # returns false
            return 0
        }
    }
    # found the array to be equal bails the script
    Exit
}


# this function will ping all the IPs within the range provided by the paramaters
#
# params $ip     an array which represents the first valid address in the range
# params $octet  tells function which octet shares the network IP
# params $max    all the values in the arrays will be under this value
function ping_range([int[]]$ip,[int]$octet,[int]$max,[int]$override){

    # bails out of the program if doing a range sweep
    if($override -ne 0){
        $null = recursive_patch $stopIP $ip
    }
    # base return case
    if($max-1 -lt ($ip[$octet])){
        return
    }
    # this shuffles the resusion down to the last octet
    elseif($octet -lt 3){
        ping_range $ip ($octet+1) 255 $override

        # hack to deal the array being passed by reference
        if($octet -eq 2){
            $ip[3]=0
        }
        if($octet -eq 1){
            $ip[2]=0
        }
        if($octet -eq 0){
            $ip[1]=0
        }
    }
    # ip address has been formed for this block, sends the ping!
    else{
        # prepares the IP info for the command
        [string]$addr = [String]$ip[0] + '.' + [String]$ip[1] + '.' + [String]$ip[2]`
        + '.' + [String]$ip[3]

        if(Test-Connection -Quiet -Count 1 $addr){
            Write-Output $addr
        }
        $ip[$octet] += 1
        return ping_range $ip $octet $max $override
    }
    # increment the octets that are not the 4th one
    $ip[$octet] += 1
    return ping_range $ip $octet $max $override
}


# main function which kick off the the script routine by parsing the i 
#
# params $userinput - the command line arguments which describe the ip range
function main([String] $userinput){

    # if cider input
    if ($userinput.Contains("/")){
        # extracts the cider information
        $delimited = $userinput.Split("/")
        #cast the cider info to an integer
        [int]$cidernum = [int]$delimited[1]

        [int[]]$ip = $delimited[0].Split(".")

        # calcuates the upper range for the cider notation
        if($cidernum -lt 8){
            [int]$octet = 0
            [int]$max = $ip[$octet] + [Math]::Pow(2,8-$cidernum)
        }
        elseif($cidernum -lt 16){
            [int]$octet = 1
            [int]$max = $ip[$octet] + [Math]::Pow(2,16-$cidernum)
        }
        elseif($cidernum -lt 24){
            [int]$octet = 2
            [int]$max = $ip[$octet] + [Math]::Pow(2,24-$cidernum)
        }
        else{
            [int]$octet = 3
            [int]$max = $ip[$octet] + [Math]::Pow(2,32-$cidernum)
        }
        # provided the function the first valid IP address to ping
        ping_range $ip $octet $max 0
    }
    # if range input
    else{
        # extracts the IP from the user input
        $delimited = $userinput.Split("-")
        $beginip = $delimited[0].Split(".")
        $endip = ($delimited[1]).Split(".")

        # hack to get the recursion to work with the range
        $Global:stopIP = $endip

        # loop to calculate the params for the ping function
        for($i=0; $i -lt 5; $i++){
            if(($endip[$i] - $beginip[$i]) -ne 0){
                return ping_range $beginip $i 255 1
            }
        }
    }
}


# kickoff of the script
main($args[0])

