[CmdletBinding()]
param (
    [switch]$System,
    [switch]$Disks,
    [switch]$Network
)

function Get-SystemReport {
    Write-Output "----CPU Information----"
    Get-WmiObject -Class Win32_Processor | Select-Object  Name, NumberOfCores, NumberOfLogicalProcessors, Manufacturer, MaxClockSpeed | Format-Table -AutoSize

    Write-Output "`n----Operating System Information----"
    Get-CimInstance -ClassName Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, ServicePackMajorVersion | Format-Table -AutoSize

    Write-Output "`n----Memory Information----"
    Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum | %{ "Total Memory: $([math]::Round(($_.Sum / 1GB),2)) GB" }

    Write-Output "`n----Video Card Information----"
    Get-WmiObject -Class CIM_VideoController | Select-Object Name, AdapterRAM, DriverVersion, VideoProcessor | Format-Table -AutoSize
}

function Get-DisksReport {
    Write-Output "----Disk Information----"
    Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3" | Select-Object DeviceID, VolumeName, @{Name="Capacity(GB)";Expression={[math]::Round(($_.Size / 1GB),2)}}, @{Name="FreeSpace(GB)";Expression={[math]::Round(($_.FreeSpace / 1GB),2)}} | Format-Table -AutoSize
}

function Get-NetworkReport {
    Write-Output "----Network Information----"
    Get-WmiObject -Class Win32_NetworkAdapterConfiguration | Select-Object Description, IPAddress, MACAddress | Where-Object {$_.IPAddress -ne $null} | Format-Table -AutoSize
}

if ($System) {
    Get-SystemReport
}
elseif ($Disks) {
    Get-DisksReport
}
elseif ($Network) {
    Get-NetworkReport
}
else {
    Get-SystemReport
    Get-DisksReport
    Get-NetworkReport
}