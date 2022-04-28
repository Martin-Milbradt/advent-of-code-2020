Push-Location $PSScriptRoot
. .\Functions.ps1

$data = ".\ValidTickets.txt"

$global:part = 2

Write-Host $(Get-Result -dataName $data)