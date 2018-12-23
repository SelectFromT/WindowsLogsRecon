# WindowsLogsRecon
Setup for and recon of all windows event logs.

This contains 2 scripts for the setup, recon and review of windows event logs.

The "Security_Logs_To_Registry_Key.ps1" parses the %systemroot%\system32\winevt\logs\ folder for all system logs. It then creates the necessary registry entries for the wmi_log_filter_dtTime.ps1 file to parse the files. This change allows for immediate parsing of logs, including from the Get-WinEvent -LogName *partial name* PowerShell method for reviewing logs. Logs are saved to C:\temp\

The wmi_log_filter_dtTime.ps1 file reviews the system event logs, using pre-filtering through the WQL to shorten search and response times. The file outputs to a CSV saved to C:\temp\

