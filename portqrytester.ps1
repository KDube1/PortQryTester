#By Krishna Dube
Start-Transcript .\transcript.txt
$nums = '0123456789' 
$alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
$ipArray =@()
$portArray =@()
$flowFile = Get-ChildItem dataflows*
foreach($line in Get-Content $flowFile) {
    $port = ''
	$address=''
	$protocol = '' #default protocol is tcp
    [bool] $portVal = $true
	[bool] $commCheck = $true
	[bool] $protocolVal = $true
	
    foreach($char in $line.toCharArray()){
        if ($nums.Contains($char) -and ($portval)){
            if ($port.Length -lt 5){
                $port = $port+ $char        
            }                             #for obtaining the port number.
        }
		
		if (-not $nums.Contains($char)){ #as soon as the script sees a letter or a space, it knows the port has been recorded.
			$portval = $false
			}
			
			
			if ($char -eq '#'){ #this line is for comments
				$commCheck = $false
				}
				
				
				if ($address.length -gt 1 -and $char -eq ' '){ 
				$protocolVal = $false
				
			}
			
					
			if ($portval -eq $false -and ($protocolVal) ){
			$address = $address + $char						#obtains ip address
				
			}
			
			
			if (($protocolVal -eq $false) -and ($commCheck)){
				$protocol= $protocol + $char
				}
				
			
			
			
			
    }
	if (-not($protocol.Contains('udp'))){
		$protocol = 'tcp'
		}
	if ($protocol.Contains('tcp')){
		$protocol = 'tcp'
		}
	$address = $address.Trim() #takes out whitespace from address
	$protocol = $protocol.Trim()
	$ipArray += $address
    portqry -n $address -e $port -p $protocol
}

Stop-Transcript

Set-Content .\result.txt 'Portqry Tester'
Add-Content .\result.txt ""

foreach($line in Get-Content .\transcript.txt) {
	if ($line.Contains("TCP port") -or $line.Contains("UDP port")){
		$portArray += $line
		}
	
}
$val = 0
while ($val -lt $portArray.length){
	$str1  = "Test for address "
	$str1 = $str1 + $ipArray[$val]
	Add-Content .\result.txt $str1
	Add-Content .\result.txt $portArray[$val]                #iterates through every result to print out result file
	Add-Content .\result.txt ''
	$val++
	}

	#text comment