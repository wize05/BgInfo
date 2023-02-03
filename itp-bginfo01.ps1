## Variables

$bgInfoFolder = "C:\Users\Public\itp\BgInfo"
$bgInfoFolderContent = $bgInfoFolder + "\*"
$itemType = "Directory"
$bgInfoUrl = "https://download.sysinternals.com/files/BGInfo.zip"
$bgInfoZip = "C:\Users\Public\itp\BgInfo\BGInfo.zip"
$bgInfoEula = "C:\Users\Public\itp\BgInfo\Eula.txt"
$logonBgiUrl = "https://github.com/wize05/BgInfo/raw/main/itp.zip"
$logonBgiZip = "C:\Users\Public\itp\BgInfo\itp.zip"
$bgInfoRegPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$bgInfoRegKey = "BgInfo"
$bgInfoRegType = "String"
$bgInfoRegKeyValue = "C:\Users\Public\itp\BgInfo\Bginfo64.exe C:\Users\Public\itp\BgInfo\info-itp.bgi /timer:0 /nolicprompt"
$regKeyExists = (Get-Item $bgInfoRegPath -EA Ignore).Property -contains $bgInfoRegkey
$writeEmptyLine = "`n"
$writeSeperator = " - "
$time = Get-Date -UFormat "%A %m/%d/%Y %R"
$foregroundColor1 = "Yellow"
$foregroundColor2 = "Red"

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Write Download started

Write-Host ($writeEmptyLine + "# BgInfo download started" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Create BgInfo folder on C:\Users\Public\itp\BgInfo if not exists, else delete its content

If (!(Test-Path -Path $bgInfoFolder)){New-Item -ItemType $itemType -Force -Path $bgInfoFolder
   Write-Host ($writeEmptyLine + "# BgInfo folder created" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor1 $writeEmptyLine
}Else{Write-Host ($writeEmptyLine + "# BgInfo folder already exists" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor2 $writeEmptyLine
   Remove-Item $bgInfoFolderContent -Force -Recurse -ErrorAction SilentlyContinue
   Write-Host ($writeEmptyLine + "# Content existing BgInfo folder deleted" + $writeSeperator + $time)`
   -foregroundcolor $foregroundColor2 $writeEmptyLine}

 ##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Download, save and extract latest BGInfo software to C:\Users\Public\itp\BgInfo

Import-Module BitsTransfer
Start-BitsTransfer -Source $bgInfoUrl -Destination $bgInfoZip
Expand-Archive -LiteralPath $bgInfoZip -DestinationPath $bgInfoFolder -Force
Remove-Item $bgInfoZip
Remove-Item $bgInfoEula
Write-Host ($writeEmptyLine + "# bginfo.exe available" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Download, save and extract logon.bgi file to C:\Users\Public\itp\BgInfo

Invoke-WebRequest -Uri $logonBgiUrl -OutFile $logonBgiZip
Expand-Archive -LiteralPath $logonBgiZip -DestinationPath $bgInfoFolder -Force
Remove-Item $logonBgiZip
Write-Host ($writeEmptyLine + "# info-itp.bgi available" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Create BgInfo Registry Key to AutoStart

If ($regKeyExists -eq $True){Write-Host ($writeEmptyLine + "BgInfo regkey exists, script wil go on" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
}Else{
New-ItemProperty -Path $bgInfoRegPath -Name $bgInfoRegkey -PropertyType $bgInfoRegType -Value $bgInfoRegkeyValue
Write-Host ($writeEmptyLine + "# BgInfo regkey added" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine}

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Run BgInfo

C:\Users\Public\itp\BgInfo\Bginfo64.exe C:\Users\Public\itp\BgInfo\info-itp.bgi /timer:0 /nolicprompt
Write-Host ($writeEmptyLine + "# BgInfo has ran for the first time" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor1 $writeEmptyLine 

##-------------------------------------------------------------------------------------------------------------------------------------------------------

## Exit PowerShell window 2 seconds after completion

Write-Host ($writeEmptyLine + "# Script completed, the PowerShell window will close in 2 seconds" + $writeSeperator + $time)`
-foregroundcolor $foregroundColor2 $writeEmptyLine
Start-Sleep 2 
stop-process -Id $PID 

##-------------------------------------------------------------------------------------------------------------------------------------------------------
