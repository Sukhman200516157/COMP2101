$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration | Where-Object { $_.IPEnabled }

$report = $adapters | Select-Object Description, Index, @{
        Label = "IP Address"
        Expression = { $_.IPAddress -join ", " }
    }, @{
        Label = "Subnet Mask"
        Expression = { $_.IPSubnet -join ", " }
    }, DNSDomain, @{
        Label = "DNS Server"
        Expression = { $_.DNSServerSearchOrder -join ", " }
    }

$report | Format-Table