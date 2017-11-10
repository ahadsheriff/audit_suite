# Contributors:   Michael Boc, Ahad Sheriff, Christian Rispoli
# Date:         09/26/2017
# File:         portscan.ps1
#
# Desc: Performs port scan on specified hosts' ports
#

# Iterates through Hosts file and resolves IPs


function scan($range, $ports){

	# Loop Addresses
	for ($i = [int64] $range['start']; $i -le [int64] $range['end']; $i++) { 
		for ($j = 0; $j -lt [int64] $ports.length; $j++) { 
			$hostip = INT64-toIP -int $i 
			#Timeout in milliseconds 

			$TCPTimeout = 1000
			$TCPClient  = New-Object  -TypeName   System.Net.Sockets.TCPClient
			$AsyncResult  = $TCPClient.BeginConnect($hostip,$ports[$j],$null,$null)
			# Wait for connection
			$Wait = $AsyncResult.AsyncWaitHandle.WaitOne($TCPtimeout) 
		
			# If finished
			If ($Wait) {
				Try  {
					$Null  = $TCPClient.EndConnect($AsyncResult)
				} Catch  {
					Write-Warning  $_
					$Issue  = $_.ToString()
				} Finally  {
					[pscustomobject]@{
					HostIP = $hostip
					Port =  $ports[$j]
					IsOpen =  $TCPClient.Connected
					Status =  'Sucessfully Connected'
				}
			}
				$Issue  = $Null
				$TCPClient.Dispose()
			} Else  {
				[pscustomobject]@{
				HostIP = $hostip
				Port =  $ports[$j]
				IsOpen =  $TCPClient.Connected
				Status =  'Failed: Connection Timeout'
				}    
			}
		}
	}
}
		

function calculate_Range([String] $start, [String] $end){
	[hashtable]$Return = @{} 
	# Generate Addresses to be scanned
	if ($end.length -eq 2) { 
		# CIDR Case where theres only one address w/ a CIDR Range
		$maskaddr = [Net.IPAddress]::Parse((INT64-toIP -int ([convert]::ToInt64(("1"*$end+"0"*(32-$end)),2))))
		$ipaddr = [Net.IPAddress]::Parse($start)
		$networkaddr = new-object net.ipaddress ($maskaddr.address -band $ipaddr.address)
		$broadcastaddr = new-object net.ipaddress (([system.net.ipaddress]::parse("255.255.255.255").address -bxor $maskaddr.address -bor $networkaddr.address))
 
		$start = IP-toINT64 -ip $networkaddr.ipaddresstostring 
		$end = IP-toINT64 -ip $broadcastaddr.ipaddresstostring 
	} else {
		# Specified Address Range
		$start = IP-toINT64 -ip $start 
		$end = IP-toINT64 -ip $end 
	}
	 
	$Return.start = $start
	$Return.end = $end

	return $Return
	}

function calculate_Port_Range([String] $pstart, [String] $pend){

	$i = 0
	for ($j = [int64] $pstart; $j -le [int64] $pend; $j++) { 
		$Return+=@($j)
		$i++
	}
	return $Return

}


function IP-toINT64 () { 
	param ($ip) 
	# The Number 65536 Is (2 ^ 16)  While 16777216 Is remaing bits in addres ( 2^24 )
	$octets = $ip.split(".") 
	return [int64]([int64]$octets[0]*16777216 +[int64]$octets[1]*65536 +[int64]$octets[2]*256 +[int64]$octets[3]) 
} 
 
function INT64-toIP() {
	# The Number 65536 Is (2 ^ 16)  While 16777216 Is remaing bits in addres ( 2^24 ) 
	param ([int64]$int) 
	return (([math]::truncate($int/16777216)).tostring()+"."+([math]::truncate(($int%16777216)/65536)).tostring()+"."+([math]::truncate(($int%65536)/256)).tostring()+"."+([math]::truncate($int%256)).tostring() )
} 

function main([String] $targets) {

	# Split for Range and Ports
	$range,$ports = $targets -split " -p "

	if (-not $ports){
		Write-Host "No Port(s) Specified"
		Write-Host "Usage: [IP-Adress Range] -p [Ports]"
	}
    	# Split String for CIDR
	if ($range -like '*/*') {
		$start,$end = $range.split('/')
		
	}
	# Split String for IP Range
	if ($range -like '*-*') {
		$start,$end = $range.split('-')
	}
	
	# Split String for Port Range
	if ($ports -like '*-*') {
		$pstart,$pend = $ports.split('-')
	}

	# Split String for Port List
	$ports = @($ports.split(','))


	# Calculate addresses based on CIDR or Given Range
   	$range = calculate_Range $start $end

	# Calculate Range if given
	if ($pstart -and $pend){
		$ports = calculate_Port_Range $pstart $pend
	}
	# Call Port Scan function with Range and Ports
	scan $range $ports

}

main "129.21.42.176-129.21.42.177 -p 443-445"
