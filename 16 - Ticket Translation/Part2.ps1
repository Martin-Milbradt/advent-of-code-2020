Push-Location $PSScriptRoot
. .\Functions.ps1

$dataName = ".\Data.txt"
$global:target = 30000000
[string] $data = Get-Content $dataName
$result = Get-Result -data $data
Assert-Equals -actual $result