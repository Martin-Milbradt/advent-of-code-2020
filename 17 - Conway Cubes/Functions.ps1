Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Get-Part1  {
    $sum = 0
    $global:cubes | foreach-object {$sum += $_}
    return $sum
}

Function Get-Part2 {
    $sum = 0
    $global:cubes | foreach-object {$sum += $_}
    return $sum
}

Function Find-Neighbors([int] $x, [int] $y, [int] $z) {
    $sum = -$global:cubes[$z,$y,$x]
    for ($i = $x-1; $i -le $x+1; $i++) {
        for ($j = $y-1; $j -le $y+1; $j++) {
            for ($k = $z-1; $k -le $z+1; $k++) {
                $sum += $global:cubes[$k,$j,$i]
            }
        }
    }
    return $sum
}

Function Update-ConwayCubes([int] $cycle) {
    $start = $cycles-$cycle 
    $newCubes = New-Object 'int[,,]' $global:dimZ,$global:dimY,$global:dimX
    for ($x = $start; $x -lt $global:dimX-$start-1; $x++) {
        for ($y = $start; $y -lt $global:dimY-$start-1; $y++) {
            for ($z = $start; $z -lt $global:dimZ-$start; $Z++) {
                $alive = Find-Neighbors $x $y $z
                if ($alive -eq 3) {
                    $newCubes[$z,$y,$x] = 1
                } elseif ($alive -eq 2) {
                    $newCubes[$z,$y,$x] = $global:cubes[$z,$y,$x]
                }
            }
        }
    }
    $global:cubes = $newCubes
}

Function New-ConwayCubes ([string] $dataName = ".\Data.txt") {
    [char[][]] $charData = Get-Content $dataName
    $global:cycles = 6
    $global:dimZ = 1+2*$cycles
    $global:dimY = $charData.Count+2*$cycles+1
    $global:dimX = $charData[0].Count+2*$cycles+1
    $global:cubes = New-Object 'int[,,]' $dimZ,$dimY,$dimX
    for ($y = 0; $y -lt $charData.Count; $y++) {
        for ($x = 0; $x -lt $charData[0].Count; $x++) {
            if ($charData[$y][$x] -eq '.') {
                $cubes[$cycles, $($y+$cycles), $($x+$cycles)] = 0
            } else {
                $cubes[$cycles, $($y+$cycles), $($x+$cycles)] = 1
            }
        }
    }
}

Function Out-ConwayCubes ([int] $cycle = 0) {
    $start = $cycles - $cycle
    for ($z = $start; $z -le $dimZ-$start-1; $z++) {
        $output = "z=$z`n"
        for ($y = $start; $y -lt $global:dimY-$start-1; $y++) {
            for ($x = $start; $x -lt $global:dimX-$start-1; $x++) {
                if ($global:cubes[$z,$y,$x] -eq 1) {
                    $output += "#"
                } else {
                    $output += "."
                }
            }
            $output += "`n"
        }
        Write-Host $output
    }
}

Function Get-Result ([string] $dataName = ".\Data.txt", [int] $cycles = 6) {
    New-ConwayCubes -cycles $cycles -dataName $dataName
    Write-Host "Cycle 0"
    Write-Host "Alive $(Get-Part1)"
    Out-ConwayCubes
    for ($i = 1; $i -le $cycles; $i++) {
        Update-ConwayCubes $i
        Write-Host "Cycle $i"
        Write-Host "Alive $(Get-Part1)"
        Out-ConwayCubes $i
    }
    if ($global:part -eq 1) {
        return Get-Part1
    }
    return Get-Part2
}