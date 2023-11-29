Push-Location $PSScriptRoot
. .\Functions.ps1

$global:part = 1

Write-Host $(Get-Result -logging $true)
