Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

$occupied = "#"
$empty = "L"
$floor = "."

$maxNeighborsEmpty = 0
$maxNeighborsOccupied = 4

[string[]] $data = Get-Content $dataName

$outerRight = @()
$outerDown = @()
$outerRightDown = @()
$outerRightBottomDown = @()
$right = (0,1)
$down = (1,0)
$downRight = (1,1)
$upRight = (-1,1)

Function Set-OuterArrays {
    for ($j=0; $j -lt $global:data[0].Length; $j++) {
        $global:outerRight += ,(0,$j)
    }
    for ($i=0; $i -lt $global:data.Length; $i++) {
        $global:outerDown += ,($i,0)
    }
    $outerRightBottom = @()
    for ($j=0; $j -lt $global:data[0].Length; $j++) {
        $outerRightBottom += ,($($global:data.Length-1),$j)
    }
    $null, $global:outerRightDown = $global:outerRight + $global:outerDown
    $null, $global:outerRightBottomDown = $outerRightBottom + $global:outerDown
}

Function Get-FinalSeats ([string[]] $data = $data) {
    [int[][]] $neighborsTemplate = Get-NeighborMatrix -data $data
    While (-not(Assert-ContentEquals $old $data)) {
        [string[]] $old = Get-Deepcopy $data
        Step -data $data -neighbors $neighborsTemplate
    }
    return Get-TakenSeats $data
}

Function Print-Data ([object[]] $data) {
    Write-Host Seats:
    Foreach ($line in $data) {
          Write-Host $line  
    }
    Write-Host
}

Function Get-NeighborMatrix ([string[]] $data) {
    [int[]] $neighborArray = ,0 * $data[0].Length
    return ,$neighborArray * $data.Length
}

Function Step ([string[]] $data = $data, [int[][]] $neighborsTemplate) {
    [int[][]]$neighbors = Get-Deepcopy $neighborsTemplate
    Parse-Right -data $data -neighbors $neighbors
    Parse-Down -data $data -neighbors $neighbors
    Parse-DownRight -data $data -neighbors $neighbors
    Parse-UpRight -data $data -neighbors $neighbors
    Set-NewData -data $data -neighbors $neighbors
}

Function Parse-Down ([string[]] $data = $data, [int[][]] $neighbors) {
    Parse-Directional -data $data -neighbors $neighbors -step $global:down -outer $global:outerRight
}

Function Parse-Right ([string[]] $data = $data, [int[][]] $neighbors) {
    Parse-Directional -data $data -neighbors $neighbors -step $global:right -outer $global:outerDown
}

Function Parse-DownRight ([string[]] $data = $data, [int[][]] $neighbors) {
    Parse-Directional -data $data -neighbors $neighbors -step $global:downRight -outer $global:outerRightDown
}

Function Parse-UpRight ([string[]] $data = $data, [int[][]] $neighbors) {
    Parse-Directional -data $data -neighbors $neighbors -step $global:upRight -outer $global:outerRightBottomDown
}

Function Parse-Directional ([string[]] $data = $data, [int[][]] $neighbors, [int[]] $step, [int[][]] $outer) {
    foreach ($start in $outer) {
        $lastOccupied = $false
        $last = $false
        for ($($i = $start[0]; $j = $start[1]); $i -lt $data.Length -and $j -lt $data[0].Length -and $i -ge 0 -and $j -ge 0; $($i+=$step[0]; $j+=$step[1])) {
            switch ($data[$i][$j]) {
                $empty  {
                    if ($lastOccupied) {$neighbors[$i][$j]++}
                    $lastOccupied = $false
                    $last = $i,$j
                    break
                }
                $occupied {
                    if ($lastOccupied) {
                        $neighbors[$i][$j]++
                    }
                    if ($last) {
                        $neighbors[$last[0]][$last[1]]++
                    }
                    $lastOccupied = $true
                    $last = $i,$j
                    break
                }
            }
        }
    }
}

Function Set-NewData ([string[]] $data, [int[][]] $neighbors) {
    for ($i = 0; $i -lt $data.Length; $i++) {
        for ($j = 0; $j -lt $data[$i].Length; $j++) {
            switch ($data[$i][$j]) {
                $empty { 
                    if ($neighbors[$i][$j] -le $maxNeighborsEmpty) {
                        $data[$i] = $data[$i].remove($j,1).insert($j,$occupied)
                    }
                    break
                }
                $occupied {
                    if ($neighbors[$i][$j] -gt $maxNeighborsOccupied) {
                        $data[$i] = $data[$i].remove($j,1).insert($j,$empty)
                    }
                    break
                }
            }
        }
    }
}

Function Get-TakenSeats ([string[]] $data = $data) {
    return "$data".split($occupied).Length-1
}

Set-OuterArrays
$seats = Get-FinalSeats

Write-Output "Seats taken: $seats"