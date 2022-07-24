Push-Location $PSScriptRoot
. .\Functions.ps1

$global:part = 1

Write-Host $(Get-Result ".\TestData.txt" -cycles 1)