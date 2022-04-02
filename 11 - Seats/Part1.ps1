Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

$occupied = "#"
$empty = "L"
$floor = "."

[string[]] $data = Get-Content $dataName
$data = Add-PaddingToArray $data

Function Get-FinalSeats ([string[]] $data = $data) {
    While (-not(Assert-ContentEquals $old $data)) {
        $old = $data
        $data = Step -data $data
    }
    return Get-TakenSeats $data
}

Function Step ([string[]] $data = $data) {
    [string[]] $newData = Get-Deepcopy $data
    for ($i = 1; $i -lt $data.Length-1; $i++) {
        for ($j = 1; $j -lt $data[$i].Length-1; $j++) {
            if ($data[$i][$j] -eq $floor) {
                continue
            }
            $area = Get-Area -data $data -i $i -j $j
            $newState = Get-NewState -area $area
            $newData[$i] = $newData[$i].remove($j,1).insert($j,$newState)
        }
    }
    return $newData
}

Function Get-Area ([string[]] $data, [int] $i, [int] $j) {
    $slice = $data[$($i-1)..$($i+1)]
    return $slice[0].Substring($j-1,3), $slice[1].Substring($j-1,3), $slice[2].Substring($j-1,3)
}

Function Get-NewState ([string[]] $area) {
    switch ($area[1][1]) {
        $global:empty { return Get-NewStateFromEmpty -area $area }
        $global:occupied { return Get-NewStateFromOccupied -area $area }
        Default { return $area[1][1]}
    }
}

Function Get-NewStateFromEmpty ([string[]] $area) {
    return Get-NewStateMaxNeighbors -area $area -maxNeighbors 0
}
Function Get-NewStateFromOccupied ([string[]] $area) {
    return Get-NewStateMaxNeighbors -area $area -maxNeighbors 3
}

Function Get-NewStateMaxNeighbors ([string[]] $area, [int] $maxNeighbors) {
    if ($(Get-Neighbors $area) -gt $maxNeighbors) {
        return $global:empty
    }
    return $global:occupied
}
Function Get-Neighbors ([string[]] $area) {
    $selfOccupied = $area[1][1] -eq $occupied
    return $(Get-TakenSeats $area) - $selfOccupied
}

Function Get-TakenSeats ([string[]] $data = $data) {
    return "$data".split($occupied).Length-1
}

$seats = Get-FinalSeats

Write-Output "Seats taken: $seats"