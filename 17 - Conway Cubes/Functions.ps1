Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Get-Part1 ([int[][]] $data) {
    return $data
}

Function Get-Part2 ([int[][]] $data) {
    
    return $data
}

Function Get-Result ([string] $dataName = ".\Data.txt", [int] $part = $global:part, [int] $cycles = 6) {
    [char[][]] $charData = Get-Content $dataName
    $dimZ = 1+2*$cycles
    $dimY = $charData.Count+2*$cycles
    $dimX = $charData[0].Count+2*$cycles
    $intData = New-Object 'int[,,]' $dimZ,$dimY,$dimX
    for ($y = 0; $y -lt $charData.Count; $y++) {
        for ($x = 0; $x -lt $charData[0].Count; $x++) {
            if ($charData[$y][$x] -eq '.') {
                $intData[$cycles, $($y+$cycles), $($x+$cycles)] = 0
            } else {
                $intData[$cycles, $($y+$cycles), $($x+$cycles)] = 1
            }
        }
    }
    if ($part -eq 1) {
        return Get-Part1 -data $intData
    }
    return Get-Part2 -data $intData
}