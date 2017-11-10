#
# Contributors: Michael Boc, Ahad Sheriff, Christian Rispoli
# Date:         09/26/2017
# File:         dns_enum.ps1
#
# Desc: Reads in a list of host names and resolves coresponding IPs
#

# Iterates through Hosts file and resolves IPs
function resolve([Object] $file){

	# Loop hosts file
	foreach($line in $file) {
		try {
			$ips = [System.Net.Dns]::GetHostAddresses($line)
			Write-Host ( 'Host: ' + $line + ' Resolved to ' + $ips )
		} catch {
			# Hostname cannot be resolve
			Write-Host ( 'Host: ' + $line + ' Cannot be Resolved' )
		}
		
	}
}

function main([String] $hostsfile) {

	# Loads Hosts file
	$hosts = Get-Content $hostsfile
	# Call resolve function
	resolve $hosts

}

main $args[0]
