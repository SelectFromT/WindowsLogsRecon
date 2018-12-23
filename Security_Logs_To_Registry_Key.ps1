#script must be run in admin mode.
#creates the missing registry keys for the system log files located at %systemroot%\system32\winevt\logs\
#note, this can be in excess of 300 logs.
#entries are only created for keys that are not already in the HKLM\SYSTEM\CurrentControlSet\Services\EventLog\ location.
#all logs go to the C:\temp\ folder.

#check to see if folder exists, if not, create:
if((Test-Path 'C:\temp\') -eq 0) 
{
    md 'C:\temp\'
}

#get system root folder
$sysRoot = $env:SystemRoot

#get information on files in the event log folder
$logList = Get-ChildItem "$sysRoot\system32\winevt\logs"

#check and add missing registry keys:
foreach($logName in $logList)
{
    #determine if the file is of .evtx format, to create the log file registry keys.
    if($logName.Name -imatch '.evtx')
    {
        #normalize the name to include / instead of %4
        #remove file type from name
        $normalizedName = $logName.Name.replace('%4','/').replace('.evtx','')
        
        #registry path of each file:
        $regLogPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog"
        if(Test-Path $regLogPath\$normalizedName\)
        {
            "$normalizedName already exists in registry at location $regLogPath" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append
        }
        else
        {
            #write result to file
            "$normalizedName did not already exist in registry at location $regLogPath" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append

            #create new key path
            $regKeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$normalizedName"

            #create new key
            #3 step process:
            #1 open registry item
            $reg = Get-Item HKLM:
            #2 open subkey located at regLogsPath:
            $key = $reg.OpenSubKey($regLogsPath.replace('HKLM:\',''),$true)
            #3 create the new key, bypassing the path restriction of / with powershell.
            $key.CreateSubKey($normalizedName)
            "$normalizedName created at location $regLogPath" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append

            #create value for File
            New-ItemProperty -Path $regKeyPath -Name File -PropertyType String -Value "$normalizedName.evtx"
            "File Subkey created at location $regLogPath\$normalizedName" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append

            #create value for Primary Module
            New-ItemProperty -Path $regKeyPath -Name 'Primary Module' -PropertyType String -Value $exampleName
            "Primary Module Subkey created at location $regLogPath\$normalizedName" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append

            #create value for windows event log API DLL - wevtapi.dll
            New-ItemProperty -Path $regKeyPath -Name 'DisplayNameFile' -PropertyType ExpandString -Value "$sysRoot\system32\wevtapi.dll"
            "DisplayNameFile Subkey created at location $regLogPath\$normalizedName" | Out-File -FilePath C:\temp\registryModificationLog.txt -Append

        }

    }
    else
    {
        #write files that are not log types.
        Write-Host ($logName.Name + " is not an event log type")
    }
}

Write-Host "Logs have been saved to C:\temp\registryModificationLog.txt"
