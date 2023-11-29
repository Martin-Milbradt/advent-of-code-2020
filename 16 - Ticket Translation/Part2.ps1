Push-Location $PSScriptRoot
. .\Functions.ps1

$data = ".\ValidTickets.txt"

$global:part = 2
# Doesn't work for the new data for some reason
Write-Host $(Get-Result -dataName $data)
