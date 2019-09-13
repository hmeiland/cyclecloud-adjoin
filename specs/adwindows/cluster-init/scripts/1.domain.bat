#Powershell.exe -executionpolicy remotesigned Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
#Powershell.exe -executionpolicy remotesigned Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.ad_domain`) DO (
  SET domain!count!=%%F
  SET /a count=!count!+1
)
ECHO %domain3%

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.ad_server`) DO (
  SET server!count!=%%F
  SET /a count=!count!+1
)
ECHO %server3%

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.ad_admin`) DO (
  SET admin!count!=%%F
  SET /a count=!count!+1
)
ECHO %admin3%

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.ad_password`) DO (
  SET password!count!=%%F
  SET /a count=!count!+1
)
ECHO %password3%

Powershell.exe -executionpolicy remotesigned $dnsip = [System.Net.Dns]::GetHostAddresses('%server3%')[0].IPAddressToString; Set-DnsClientServerAddress -InterfaceAlias Ethernet -ServerAddresses "$dnsip","168.63.129.16" 

Powershell.exe -executionpolicy remotesigned $password = ConvertTo-SecureString "%password3%" -asPlainText -Force; $credential = New-Object System.Management.Automation.PSCredential('%domain3%\%admin3%',$password); Add-Computer -DomainName '%domain3%' -Credential $credential

Powershell.exe -executionpolicy remotesigned "Add-LocalGroupMember -Group 'Remote Desktop Users' -Member ('%domain3%\Domain Users')"

echo "need to reboot" > D:\reboot.txt


ENDLOCAL
