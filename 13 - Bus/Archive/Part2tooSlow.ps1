Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

[string[]] $data = Get-Content $dataName

Function Get-BusChainTime {
    $busses = $bussesWithOffset.keys | Sort-Object -Descending
    $firstOffset = $bussesWithOffset[$busses[0]]
    $timestep = $busses[0]
    for ($timestamp=$timestep-$firstOffset; timeDoesntFit $timestamp; $timestamp+=$timestep) {
        Write-Host $timestamp
    }
    return $timestamp
}

Function Get-Busses ([string] $busses) {
    $allBusses = $busses -split ","
    $activeBusses = @{}
    for ($i = 0; $i -lt $allBusses.Length; $i++) {
        if ($allBusses[$i] -match '^\d+$') {
            $activeBusses[[int] $allBusses[$i]] = $i
        }
    }
    $global:bussesWithoutFirst = $($activeBusses.keys | Sort-Object -Descending)[1..$($activeBusses.count-1)] 
    return $activeBusses
}

Function timeDoesntFit ([int] $timestamp) {
    foreach ($bus in $bussesWithoutFirst) {
        if (($timestamp + $bussesWithOffset[$bus]) % $bus -eq 0) {
            continue
        }
        return $true
    }
    return $false
}

$bussesWithOffset = Get-Busses $data[1]
$timestamp = Get-BusChainTime

Write-Output "Timestamp: $timestamp"