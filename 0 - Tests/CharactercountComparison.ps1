Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
$iterations = 1000

[string[]] $data = Get-Content $dataName
$data = Add-PaddingToArray $data

Function Loop ([string] $function, [int] $iterations = 100) {
    for ($i = 0; $i -lt $iterations; $i++) {    
        [string[]] $newData = & $function $data
    }
}

Function Get-TakenSeats ([string[]] $data = $data) {
    return "$data".split("L").Length-1
}

Function Get-TakenSeatsRegex ([string[]] $data = $data) {
    return ([regex]::Matches($data, "L" )).count
}
Function Get-Selectstring ([string[]] $data = $data) {
    return (Select-String "L" -InputObject $data -AllMatches).Matches.Count
}

Measure-Command -Expression {Loop "Get-TakenSeats" $iterations}
Measure-Command -Expression {Loop "Get-TakenSeatsRegex" $iterations}
Measure-Command -Expression {Loop "Get-Selectstring" $iterations}