Push-Location $PSScriptRoot
. .\Functions.ps1

$global:part = 1

Get-Result ".\Data.txt"