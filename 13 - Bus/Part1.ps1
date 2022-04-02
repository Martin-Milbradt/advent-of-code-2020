Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

[string[]] $data = Get-Content $dataName
$minWaitTime

Function Get-ParseDataAndGetNextBus ([string[]] $data) {
    [int] $start = $data[0]
    $busses = Get-Busses $data[1]
    return Get-NextBus -start $start -busses $busses
}

Function Get-Busses ([string] $busses) {
    $allBusses = $busses -split ","
    [int[]] $activeBusses = @()
    foreach ($bus in $allBusses) {
        if ($bus -match '^\d+$') {
            $activeBusses += $bus
        }
    }
    return $activeBusses
}

Function Get-NextBus ([int] $start, [int[]] $busses) {
    $minWaitTime = [double]::PositiveInfinity
    foreach ($bus in $busses) {
        if ($bus - $start % $bus -lt $minWaitTime) {
            $nextBus = $bus
            $minWaitTime = $bus - $start % $bus
        }
        if ($start % $bus -eq 0) {
            $global:minWaitTime = 0
            return $bus
        }
    }
    $global:minWaitTime = $minWaitTime
    return $nextBus
}

$nextBus = Get-ParseDataAndGetNextBus -data $data

Write-Output "Next Bus: $nextBus Wait time: $minWaitTime Result: $($nextBus*$minWaitTime)"