Push-Location $PSScriptRoot
. .\Functions.ps1

$dataName = ".\Data.txt"
$global:target = 2020
[string] $data = Get-Content $dataName
Get-Result -data $data