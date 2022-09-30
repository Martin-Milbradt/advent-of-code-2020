Push-Location $PSScriptRoot
. .\Functions.ps1

$testDataName = ".\TestData.txt"

$global:part = 1

$results = Get-Result -dataName $testDataName
$expected = 26,237,12240,13632
for ($i = 0; $i -lt $results.Count; $i++) {
    Assert-Equals -expected $expected[$i] -actual $results[$i]
}