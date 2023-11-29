Push-Location $PSScriptRoot
. .\Functions.ps1

$testDataName = ".\TestData.txt"
$testData2Name = ".\TestData2.txt"

$global:part = 1

$result = Get-Result -dataName $testDataName
Assert-Equals -expected 71 -actual $result

$result = Get-Result
Assert-Equals -expected 20013 -actual $result

$global:part = 2

$result = Get-Result -dataName $testData2Name
Assert-Equals -expected 1 -actual $result

$result = Get-Result -dataName "ValidTickets old.txt"
Assert-Equals -expected 3029180675981 -actual $result

return

$result = Get-Result
Assert-Equals -actual $result
