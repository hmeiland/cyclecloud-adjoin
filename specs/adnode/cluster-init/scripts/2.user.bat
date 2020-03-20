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

SETLOCAL ENABLEDELAYEDEXPANSION
SET count=1
FOR /F "tokens=* USEBACKQ" %%F IN (`jetpack config adjoin.user`) DO (
  SET user!count!=%%F
  SET /a count=!count!+1
)
ECHO %user3%

:WAIT
timeout /t 5 > NUL
for /f "tokens=4" %%s in ('sc query ADWS ^| find "STATE"') do if NOT "%%s"=="RUNNING" goto WAIT
echo Service is now running!

Powershell.exe -executionpolicy remotesigned New-ADUser -Name '%user3%' -GivenName '%user3%' -Surname '%user3%' -SamAccountName '%user3%' -UserPrincipalName '%user3%@%domain3%' -AccountPassword(ConvertTo-SecureString '%password3%' -AsPlainText -Force) -Enabled $true

ENDLOCAL
