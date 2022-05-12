Push-Location $PSScriptRoot
. .\Functions.ps1

$global:part = 2

Write-Host $(Get-Result)