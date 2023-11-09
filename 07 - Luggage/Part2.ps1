Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$target = "shiny gold"

$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"
#$dataName = ".\TestdataTwo.txt"

[string[]] $data = Get-Content $dataName

Function Initialize-Rules ([string[]] $data) {
    $data | ForEach-Object {
        New-ColorMap -line $_
    }
}

Function Remove-UnneccesaryInformation ([string] $line) {
    $line = $line -replace ' ?[,.] ?',' '
    $line = $line -replace ' ?bags? ?',' '
    $line = $line -replace ' ?contain ?',' '
    $line = $line.trim()
    return $line
}

Function New-ColorMap ([string] $line) {
    $line = Remove-UnneccesaryInformation -line $line
    $array = $line -split " "
    $outer = Get-Color -array $array[0, 1]
    $inner = Get-Inner -array $array
    $global:rules[$outer] = $inner;
}

Function Get-Color ([string[]] $array) {
    return $($array[0] + " " + $array[1])
}

Function Get-Inner ([string[]] $array) {
    $inner = @{}
    for ($i = 2; $i -lt $($array.Length-2); $i += 3) {
        $name = $(Get-Color -array $array[$($i+1), $($i+2)])
        $inner += @{ $name = $array[$i]; }
    }
    return $inner
}

Function Get-NumberOfBagsInTarget ([string] $target = $target) {
    $check = $rules.$target
    $numberOfBags = 0
    foreach ($bag in $check.keys) {
        $bagsInEach = Get-NumberOfBagsInTarget -target $bag
        $numberOfBags += ($bagsInEach + 1) * $check[$bag]
    }
    return $numberOfBags
}

$rules = @{}
Initialize-Rules -data $data
$null = $rules | Sort-Object

Write-Output "Bags contained in a $target bag: $(Get-NumberOfBagsInTarget)"