Push-Location $PSScriptRoot
. .\Functions.ps1

$dataName = ".\Data.txt"
$testDataName = ".\TestData.txt"
$testData2Name = ".\TestData.txt"

$global:target = 2020
[string[]] $testData = Get-Content $testDataName

for ($i = 1; $i -lt $testData.Length; $i += 2) {
    $expected = $testData[$i-1]
    $result = Get-Result -data $testData[$i]
    Assert-Equals -expected $expected -actual $result
}

[string] $data = Get-Content $dataName
$result = Get-Result -data $data
Assert-Equals -expected 496 -actual $result

$global:target = 30000000

[string[]] $testData = Get-Content $testData2Name

for ($i = 1; $i -lt $testData.Length; $i += 2) {
    $expected = $testData[$i-1]
    $result = Get-Result -data $testData[$i]
    Assert-Equals -expected $expected -actual $result
}

[string] $data = Get-Content $dataName
$result = Get-Result -data $data
Assert-Equals -expected 883 -actual $result