# Stop the windows update service
Get-Service -Name wuauserv | Stop-Service -Force -Verbose -ErrorAction SilentlyContinue

# Deletes the contents of windows software distribution
Get-ChildItem "C:\Windows\SoftwareDistribution\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue

# Deletes the contents of the Windows Temp folder
Get-ChildItem "C:\Windows\Temp\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete)) } | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue

# Delets all files and folders in user's Temp folder.
Get-ChildItem "C:\users\*\AppData\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue | Where-Object { ($_.CreationTime -lt $(Get-Date).AddDays(-$DaysToDelete)) } | remove-item -force -Verbose -recurse -ErrorAction SilentlyContinue

## Remove all files and folders in user's Temporary Internet Files.
Get-ChildItem "C:\users\*\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -Verbose -ErrorAction SilentlyContinue | Where-Object { ($_.CreationTime -le $(Get-Date).AddDays(-$DaysToDelete)) } | remove-item -force -recurse -ErrorAction SilentlyContinue

# Deletes the contents of the recycling Bin
$objFolder.items() | ForEach-Object { Remove-Item $_.path -ErrorAction Ignore -Force -Verbose -Recurse }

# Start the Windows Update Service
Get-Service -Name wuauserv | Start-Service -Verbose

# Clear all event Logs
wevtutil el | Foreach-Object { wevtutil cl "$_" }