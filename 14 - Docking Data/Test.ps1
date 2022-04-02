Push-Location $PSScriptRoot
. .\Functions.ps1

$dataName = ".\Data.txt"
$testDataName = ".\TestData.txt"
$testData2Name = ".\TestData2.txt"

$global:part = 1

$result = Get-Result -dataName $testDataName
Assert-Equals -expected 165 -actual $result

$result = Get-Result -dataName $dataName
Assert-Equals -expected 15919415426101 -actual $result

$global:part = 2

$result = Get-Result -dataName $testData2Name
Assert-Equals -expected 208 -actual $result

$result = Get-Result -dataName $dataName
Assert-Equals -actual $result