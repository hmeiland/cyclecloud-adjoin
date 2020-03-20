Powershell.exe -executionpolicy remotesigned Install-WindowsFeature AD-Domain-Services -IncludeAllSubFeature -IncludeManagementTools
Powershell.exe -executionpolicy remotesigned Install-WindowsFeature DNS -IncludeAllSubFeature -IncludeManagementTools

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.domain`) DO (
  SET domain!count!=%%F
  SET /a count=!count!+1
)
ECHO %domain3%

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.password`) DO (
  SET password!count!=%%F
  SET /a count=!count!+1
)
ECHO %password3%

Powershell.exe -executionpolicy remotesigned Install-ADDSForest -CreateDnsDelegation:$false -DomainName '%domain3%' -InstallDns  -DomainMode Win2012R2 -ForestMode Win2012R2 -DatabasePath C:\Windows\NTDS -SysvolPath C:\Windows\SYSVOL -LogPath C:\Windows\Logs -NoRebootOnCompletion:$false -Force -SafeModeAdministratorPassword (ConvertTo-SecureString '%password3%' -AsPlainText -Force)


ENDLOCAL
