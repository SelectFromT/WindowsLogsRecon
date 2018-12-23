#Set date time:
$curDT = (Get-Date).ToString("yyyyMMddHHmmss")
#output File:
$outputFile = "C:\Temp\LogFiles_$curDT.csv"


#set initial time: time of event of interest
$eventDT = Get-Date(Read-Host('Enter Date Time of event in format similar to MM/DD/YYYY hh:mm:ss AM/PM: '))
$eventTimeDiff = Read-Host('Enter Time differential in minutes (+/- time around event): ')
$computer = Read-Host('Enter computer name')


#create a start/end time for the search, in minutes.
$wmiStartTime = ([System.Management.ManagementDateTimeConverter]::ToDmtfDateTime($eventDT.ToUniversalTime().AddMinutes(-$eventTimeDiff))).replace('+','-')
$wmiEndTime = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime($eventDT.ToUniversalTime().AddMinutes($eventTimeDiff)).replace('+','-')

#query all event logs for event times
$wqlQuery = "SELECT * FROM Win32_NTLogEvent where TimeGenerated >= '" + $wmiStartTime + "' AND TimeGenerated <= '" + $wmiEndTime + "'"

#check to see if folder exists, if not, create:
if((Test-Path 'C:\temp\') -eq 0) 
{
    md 'C:\temp\'
}

#output query information to log file
Get-WmiObject -Query $wqlQuery -ComputerName $computer | Sort-Object TimeGenerated -Descending | Export-Csv $outputFile -NoTypeInformation 

#open with default CSV viewer
ii $outputFile
