Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"

[string[]] $data = Get-Content $dataName
$data = Add-PaddingToArray $data

Function DeepCopyLoop ([int] $iterations = 100) {
    for ($i = 0; $i -lt $iterations; $i++) {    
        [string[]] $newData = Get-Deepcopy $data
    }
    Write-Host $newData
    Write-Host $newData.Length
}

Function ArrayCopyLoop ([int] $iterations = 100) {
    for ($i = 0; $i -lt $iterations; $i++) {    
        $newData = Get-ArrayCopy $data
    }
    Write-Host $newData
    Write-Host $newData.Length
}

Function Get-ArrayCopy ([string[]] $data = $data) {
    $newData = $()
    $data | ForEach-Object {    
        $newData += ,$_
    }
    return $newData
}

Measure-Command -Expression {DeepCopyLoop}
Measure-Command -Expression {ArrayCopyLoop}