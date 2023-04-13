# System information script

Write-Output "Computer System Information"

#Creating Functions

function Get-ComputerSystem {
    $computerSystem = Get-WmiObject win32_computersystem
    if (!$computerSystem) {
        Write-Warning "Failed to retrieve system information."
        return
    }
    $manufacturer = $computerSystem.Manufacturer
    $model = $computerSystem.Model
    $systemType = $computerSystem.SystemType
    $processorType = $computerSystem.SystemType
    [PSCustomObject]@{
        "Manufacturer" = $manufacturer
        "Model" = $model
        "System Type" = $systemType
        "Processor Type" = $processorType
    }
}

$systemInfo = Get-ComputerSystem 

if ($systemInfo) {
    Write-Output "Manufacturer: $($systemInfo.Manufacturer)"
    Write-Output "Model: $($systemInfo.Model)"
    Write-Output "System Type: $($systemInfo.'System Type')"
    Write-Output "Processor Type: $($systemInfo.'Processor Type')"
} else {
    Write-Output "Failed to retrieve system information."
}

Write-Output ""

function Get-OperatingSystem {
    $operatingSystem = Get-WmiObject win32_operatingsystem
    if (!$operatingSystem) {
        Write-Warning "Failed to retrieve operating system information."
        return
    }
    # Store the operating system name and version in variables
    $osName = $operatingSystem.Caption
    $osVersion = $operatingSystem.Version
    # Output the operating system name and version in a custom object
    [PSCustomObject]@{
        "Name" = $osName
        "Version" = $osVersion
    }
}

$osInfo = Get-OperatingSystem

if ($osInfo) {
    Write-Host "Operating System Information"
    $osInfo | Format-List
} else {
    Write-Host "Failed to retrieve operating system information."
}
Write-Output "Processor Information"
function Get-Processor {
    $processor = Get-WmiObject win32_processor -ErrorAction SilentlyContinue
    if (!$processor) {
        Write-Warning "Failed to retrieve processor information."
        return
    }
    $processorDescription = $processor.Description
    $processorSpeed = $processor.MaxClockSpeed
    $processorCores = $processor.NumberOfCores
    $processorL1Cache = $processor.L2CacheSize
    $processorL2Cache = $processor.L3CacheSize
    [PSCustomObject]@{
        "Description" = $processorDescription
        "Speed" = "$processorSpeed MHz"
        "Number of Cores" = $processorCores
        "L1 Cache" = if ($processorL1Cache) {"$processorL1Cache KB"} else {"N/A"}
        "L2 Cache" = if ($processorL2Cache) {"$processorL2Cache KB"} else {"N/A"}
    }
}

Get-Processor | Format-List

Write-Output "Memory Information"

function Get-Memory {
    $ram = Get-WmiObject win32_physicalmemory -ErrorAction SilentlyContinue
    if (!$ram) {
        Write-Warning "Failed to retrieve memory information."
        return
    }
    $ramTable = @()
    foreach ($dimm in $ram) {
        $manufacturer = $dimm.Manufacturer
        $description = $dimm.Description
        $size = $dimm.Capacity / 1GB
        $bank = $dimm.BankLabel
        $slot = $dimm.DeviceLocator
        $ramTable += [PSCustomObject]@{
            "Manufacturer" = $manufacturer
            "Description" = $description
            "Size" = "$($size.ToString("N2")) GB"
            "Bank" = if ($bank) {$bank} else {"N/A"}
            "Slot" = if ($slot) {$slot} else {"N/A"}
        }
    }
    $ramTotal = $ram.Capacity / 1GB
    if (!$ramTotal) {
        Write-Warning "Failed to retrieve total memory information."
        return
    }
    $ramTable | Sort-Object Size -Descending | Format-Table -AutoSize
    [PSCustomObject]@{
        "Total RAM" = "$($ramTotal.ToString("N2")) GB"
    }
}
Get-Memory | Format-Table



Write-Output "Disk Information"
function Get-Disk {
    $disks = Get-WmiObject win32_diskdrive -ErrorAction SilentlyContinue
    if (!$disks) {
        Write-Host "No disk information available."
        return
    }
    $diskTable = @()
    foreach ($disk in $disks) {
        $vendor = $disk.Manufacturer
        $model = $disk.Model
        $size = $disk.Size / 1GB
        $partitions = Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskDrive.DeviceID='$($disk.DeviceID)'} WHERE AssocClass = Win32_DiskDriveToDiskPartition" -ErrorAction SilentlyContinue
        if (!$partitions) {
            $logicalDiskTable = [PSCustomObject]@{
                "Drive Letter" = "N/A"
                "Size" = "N/A"
                "Free Space" = "N/A"
                "Percent Free" = "N/A"
            }
        }
        else {
            $logicalDisks = foreach ($partition in $partitions) {
                Get-WmiObject -Query "ASSOCIATORS OF {Win32_DiskPartition.DeviceID='$($partition.DeviceID)'} WHERE AssocClass = Win32_LogicalDiskToPartition" -ErrorAction SilentlyContinue
            }
            $logicalDiskTable = @()
            foreach ($logicalDisk in $logicalDisks) {
                $driveLetter = $logicalDisk.DeviceID
                $size = $logicalDisk.Size / 1GB
                $freeSpace = $logicalDisk.FreeSpace / 1GB
                $percentFree = "{0:N2}%" -f ($freeSpace / $size * 100)
                $logicalDiskTable += [PSCustomObject]@{
                    "Drive Letter" = $driveLetter
                    "Size" = "$($size.ToString("N2")) GB"
                    "Free Space" = "$($freeSpace.ToString("N2")) GB"
                    "Percent Free" = $percentFree
                }
            }
        }
        $diskTable += [PSCustomObject]@{
            "Vendor" = if ($vendor) {$vendor} else {"N/A"}
            "Model" = if ($model) {$model} else {"N/A"}
            "Size" = "$($size.ToString("N2")) GB"
            "Partitions" = $logicalDiskTable
        }
    }
    $diskTable | Format-Table -AutoSize
}

Get-Disk
function Get-EnabledNetworkAdapters {
    $adapterConfigs = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object {$_.IPEnabled -eq $true}
    if ($adapterConfigs) {
        return $adapterConfigs | ForEach-Object {
            [PSCustomObject]@{
                Description = $_.Description
                Index = $_.Index
                IPAddress = $_.IPAddress -join ", "
                SubnetMask = $_.IPSubnet -join ", "
                DNSDomain = $_.DNSDomain
                DNSServer = $_.DNSServerSearchOrder -join ", "
            }
        }
    } else {
        return [PSCustomObject]@{
            Description = "N/A"
            Index = "N/A"
            IPAddress = "N/A"
            SubnetMask = "N/A"
            DNSDomain = "N/A"
            DNSServer = "N/A"
        }
    }
}

function Get-VideoController {
    $videoController = Get-CimInstance Win32_VideoController
    if ($videoController) {
        return [PSCustomObject]@{
            Description = $videoController.Description
            Vendor = $videoController.VideoProcessor
            ScreenResolution = "$($videoController.CurrentHorizontalResolution) x $($videoController.CurrentVerticalResolution)"
        }
    } else {
        return [PSCustomObject]@{
            Description = "N/A"
            Vendor = "N/A"
            ScreenResolution = "N/A"
        }
    }
}

$enabledAdapters = Get-EnabledNetworkAdapters
$videoController = Get-VideoController

Write-Host "Enabled Network Adapters"
if ($enabledAdapters -ne "N/A") {
    $enabledAdapters | Format-Table -AutoSize
} else {
    Write-Host "Data unavailable"
}

Write-Host "Video Controller"
if ($videoController -ne "N/A") {
    $videoController | Format-Table -AutoSize
} else {
    Write-Host "Data unavailable"
}