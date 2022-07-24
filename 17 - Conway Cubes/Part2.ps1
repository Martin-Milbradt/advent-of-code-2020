Push-Location $PSScriptRoot
. .\Functions.ps1

Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Get-Alive {
    $sum = 0
    $global:cubes | foreach-object {$sum += $_}
    return $sum
}

Function Find-Neighbors([int] $x, [int] $y, [int] $z, [int] $w) {
    $sum = -$global:cubes[$w,$z,$y,$x]
    for ($i = $x-1; $i -le $x+1; $i++) {
        for ($j = $y-1; $j -le $y+1; $j++) {
            for ($k = $z-1; $k -le $z+1; $k++) {
                for ($l = $w-1; $l -le $w+1; $l++) {
                    $sum += $global:cubes[$l,$k,$j,$i]
                }
            }
        }
    }
    return $sum
}

Function Update-ConwayCubes([int] $cycle) {
    $start = $cycles-$cycle 
    $newCubes = New-Object 'int[,,,]' $global:dimW,$global:dimZ,$global:dimY,$global:dimX
    for ($x = $start; $x -lt $global:dimX-$start-1; $x++) {
        for ($y = $start; $y -lt $global:dimY-$start-1; $y++) {
            for ($z = $start; $z -lt $global:dimZ-$start; $z++) {
                for ($w = $start; $w -lt $global:dimW-$start; $w++) {
                    $alive = Find-Neighbors $x $y $z $w
                    if ($alive -eq 3) {
                        $newCubes[$w,$z,$y,$x] = 1
                    } elseif ($alive -eq 2) {
                        $newCubes[$w,$z,$y,$x] = $global:cubes[$w,$z,$y,$x]
                    }
                }
            }
        }
    }
    $global:cubes = $newCubes
}

Function New-ConwayCubes ([string] $dataName = ".\Data.txt") {
    [char[][]] $charData = Get-Content $dataName
    $global:cycles = 6
    $global:dimW = 1+2*$cycles
    $global:dimZ = 1+2*$cycles
    $global:dimY = $charData.Count+2*$cycles+1
    $global:dimX = $charData[0].Count+2*$cycles+1
    $global:cubes = New-Object 'int[,,,]' $dimW,$dimZ,$dimY,$dimX
    for ($y = 0; $y -lt $charData.Count; $y++) {
        for ($x = 0; $x -lt $charData[0].Count; $x++) {
            if ($charData[$y][$x] -eq '.') {
                $cubes[$cycles, $cycles, $($y+$cycles), $($x+$cycles)] = 0
            } else {
                $cubes[$cycles, $cycles, $($y+$cycles), $($x+$cycles)] = 1
            }
        }
    }
}

Function Get-Result ([string] $dataName = ".\Data.txt", [int] $cycles = 6) {
    New-ConwayCubes -cycles $cycles -dataName $dataName
    Write-Host "Cycle 0"
    Write-Host "Alive $(Get-Part1)"
    for ($i = 1; $i -le $cycles; $i++) {
        Update-ConwayCubes $i
        Write-Host "Cycle $i"
        Write-Host "Alive $(Get-Part1)"
    }
}

Get-Result ".\Data.txt"