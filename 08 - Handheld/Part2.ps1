Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$data = Get-ContentAsMatrix .\Data.txt
$testdata = Get-ContentAsMatrix .\Testdata.txt

$acc = 0
$accTemp = 0

Function Step-Calculation  ([string[][]] $data, [int] $pos){
    $val = $data[$pos][1]
    $op = $data[$pos][0]
    if ($op -eq "acc" ) {
        $global:accTemp += $val;
        return $pos+1
    }
    return $pos + $(Step-Op -op $op -val $val)
}

Function Step-CalculationOneReplacement ([string[][]] $data, [int] $pos, [int[]] $visited){
    $val = $data[$pos][1]
    $op = $data[$pos][0]
    if ($op -eq "acc" ) {
        $global:acc += $val;
        return $pos+1
    }
    return Step-OneReplacement -data $data -pos $pos -visited $visited -op $op -val $val
}

Function Step-OneReplacement ([string[][]] $data, [int] $pos, [int[]] $visited, [string] $op) {
    $replacementResult = Get-ReplacementResult -data $data -pos $pos -visited $visited -op $op
    if ($replacementResult -eq $data.Count) {
        $global:acc = $global:accTemp
        return $replacementResult
    }
    return $pos + $(Step-Op -op $op -val $val)
}

Function Get-ReplacementResult ([string[][]] $data, [int] $pos, [int[]] $visited, [string] $op, [int] $val) {
    $altOp = Get-AltOp $op
    $replacementPos = $pos + $(Step-Op -op $altOp -val $val)
    return CalculateToEndOrFirstRevisit -data $data -pos $replacementPos -visited $visited
}

Function Step-Op ([string] $op, [int] $val) {
    if ($op -eq "jmp") {
        return $val
    }
    return 1
}

Function Get-AltOp ([string] $op) {
    if ($op -eq "nop") {
        return "jmp"
    }
    return "nop"
}

Function CalculateToEndOrFirstRevisit ([string[][]] $data, [int] $pos, [int[]] $visited) {
    $global:accTemp = $global:acc
    while ($visited -notcontains $pos -and $pos -ne $data.Count ) {
        $visited += $pos
        $pos = Step-Calculation -data  $data -pos $pos
    }
    return $pos
}

Function CalculateToEndOneReplacement ([string[][]] $data = $global:data, [int] $pos = 0) {
    $visited = @()
    while ($pos -ne $data.Count) {
        $visited += $pos
        $pos = Step-CalculationOneReplacement -data  $data -pos $pos -visited $visited
    }
}

CalculateToEndOneReplacement -data $data
Write-Output "Accumulator: $acc"