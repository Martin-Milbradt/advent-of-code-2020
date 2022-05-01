Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force
 
Function Modify-Array([string[]] $array) {
    $array[1] = 4
}

$array = @(1,2,3)
Modify-Array $array
Write-Host $array

$array = @(@(1,2),@(2,3))
$flat = $(Flatten -object $array)
$group = $flat | Group-Object | Sort-Object -Property Count