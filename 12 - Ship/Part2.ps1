Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

[string[]] $data = Get-Content $dataName

enum Direction {
    N
    E
    S
    W
}

$numberOfDirections = [Direction].GetEnumNames().length

$startPos = 0,0
$waypointPos = 1,10

$directionArray

$commands = @{
    "N" = "Move-North";
    "S" = "Move-South";
    "E" = "Move-East";
    "W" = "Move-West";
    "L" = "Turn-Left";
    "R" = "Turn-Right";
    "F" = "Move-Forward";
}

Function Get-DistanceFromStart ([string[]] $instructions = $data, [int[]] $pos = (0,0)) {
    foreach ($instruction in $instructions) {
        Execute-Instruction -instruction $instruction -pos $pos -waypointPos $waypointPos
    }
    return Get-Distance $pos $startPos
}

Function Execute-Instruction ([string] $instruction, [int[]] $pos, [int[]] $waypointPos) {
        $command = $commands[[string] $instruction[0]]
        & $command -pos $pos -waypointPos $waypointPos -amount $(-join $instruction[1..$($instruction.length-1)])
        Write-Host "Command: $instruction Position: ($pos), (Waypoint: $global:waypointPos)"
}
Function Move-Forward ([int[]] $pos, [int[]] $waypointPos, [int] $amount) {
    $pos[0] += $waypointPos[0]*$amount
    $pos[1] += $waypointPos[1]*$amount
}
Function Move-North ([int[]] $waypointPos, [int] $amount) {
    $global:waypointPos[0] += $amount
}

Function Move-South ([int[]] $waypointPos, [int] $amount) {
    $global:waypointPos[0] -= $amount
}

Function Move-East ([int[]] $waypointPos, [int] $amount) {
    $global:waypointPos[1] += $amount
}

Function Move-West ([int[]] $waypointPos, [int] $amount) {
    $global:waypointPos[1] -= $amount
}

Function Turn-Right ([int[]] $pos, [int[]] $waypointPos, [int] $amount) {
    Turn $pos $waypointPos $($amount % 360)
}

Function Turn-Left ([int[]] $pos, [int[]] $waypointPos, [int] $amount) {
    Turn $pos $waypointPos $(360 - $amount % 360)
}

Function Turn ([int[]] $pos, [int[]] $waypointPos, [int] $amount) {
    switch ($amount) {
        0 { $relationToSelf = 1;
            $relationToOther = 0;
            break }
        90 { $relationToSelf = 0;
            $relationToOther = 1;
            break }
        180 { $relationToSelf = -1;
            $relationToOther = 0;
            break }
        270 { $relationToSelf = 0;
            $relationToOther = -1;
            break }
    }
    $tempFirst = $waypointPos[0] * $relationToSelf - $waypointPos[1] * $relationToOther
    $global:waypointPos[1] = $waypointPos[1] * $relationToSelf + $waypointPos[0] * $relationToOther
    $global:waypointPos[0] = $tempFirst 
}

Function Get-Distance ([int[]] $pos = (0,0), [int[]] $startPos = (0,0)) {
    $distance = 0
    for ($i=0; $i -lt $pos.Length; $i++) {
        $distance += [Math]::Abs($pos[$i]-$startPos[$i])
    }
    return $distance
}

Function Cos ([int] $rotation) {

}
Function Cos ([int] $rotation) {

}

$distance = Get-DistanceFromStart -startPos $startPos -instructions $data

Write-Output "Dinstance from start: $distance"