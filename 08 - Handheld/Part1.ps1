Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$data = Get-ContentAsMatrix .\Data.txt
$testdata = Get-ContentAsMatrix .\Testdata.txt

$acc = 0

Function Step-Calculation  ([string[][]] $data, [int] $pos){
    switch ($data[$pos][0]) {
        "nop" { Break }
        "acc" { $global:acc += $data[$pos][1]; Break }
        "jmp" { return $pos + $data[$pos][1] }
        Default { throw "Invalid command: $($data[$pos])"}
    }
    return $pos + 1
}

Function CalculateToFirstRevisit ([string[][]] $data = $global:data) {
    $visited = @()
    $pos = 0
    while ($visited -notcontains $pos) {
        $visited += $pos
        $pos = Step-Calculation -data  $data -pos $pos
    }
}

CalculateToFirstRevisit -data $data
Write-Output "Accumulator: $acc"