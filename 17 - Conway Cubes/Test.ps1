Push-Location $PSScriptRoot
. .\Functions.ps1

$testDataName = ".\TestData.txt"

$global:part = 1

Write-Host $(Get-Result -dataName $testDataName)