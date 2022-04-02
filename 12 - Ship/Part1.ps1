Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"

[string[]] $data = Get-Content $dataName

enum Direction
{
    N
    E
    S
    W
}

$numberOfDirections = [Direction].GetEnumNames().length

$startPos = 0,0

$facing = [Direction] "E"

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

Function Get-DistanceFromStart ([string[]] $instructions = $data, [int[]] $startPos = (0,0)) {
    $pos = $startPos.Clone()
    foreach ($instruction in $instructions) {
        Execute-Instruction -instruction $instruction -pos $pos
    }
    return Get-Distance $pos $startPos
}

Function Execute-Instruction ([string] $instruction, [int[]] $pos = (0,0)) {
        $command = $commands[[string] $instruction[0]]
        & $command $pos $(-join $instruction[1..$($instruction.length-1)])
}
Function Move-Forward ([int[]] $pos = (0,0), [int] $amount) {
    $command = $commands[[string] $facing]
    & $command $pos $amount
}
Function Move-North ([int[]] $pos = (0,0), [int] $amount) {
    $pos[0] += $amount
}

Function Move-South ([int[]] $pos = (0,0), [int] $amount) {
    $pos[0] -= $amount
}

Function Move-East ([int[]] $pos = (0,0), [int] $amount) {
    $pos[1] += $amount
}

Function Move-West ([int[]] $pos = (0,0), [int] $amount) {
    $pos[1] -= $amount
}

Function Turn-Right ([int[]] $pos = (0,0), [int] $amount) {
    Turn $amount
}

Function Turn-Left ([int[]] $pos = (0,0), [int] $amount) {
    Turn $($amount*-1)
}

Function Turn ([int] $amount) {
    $facing = ([int]$facing + $amount/90) % $numberOfDirections
    [Direction] $global:facing = ($facing -ge 0) ? $facing : $facing + $numberOfDirections

}

Function Get-Distance ([int[]] $pos = (0,0), [int[]] $startPos = (0,0)) {
    $distance = 0
    for ($i=0; $i -lt $pos.Length; $i++) {
        $distance += [Math]::Abs($pos[$i]-$startPos[$i])
    }
    return $distance
}

$distance = Get-DistanceFromStart -startPos $startPos -instructions $data

Write-Output "Dinstance from start: $distance"