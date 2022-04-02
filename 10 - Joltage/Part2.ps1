Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$dataName = ".\Data.txt"
#$dataName = ".\TestData.txt"
#$dataName = ".\TestDataShort.txt"

[int[]] $data = Get-Content $dataName

Function Expand-Data ([int[]] $data = $global:data) {
    return ,0 + $data + $($data[-1]+3)
}

Function Get-ArrangementOptions ([int[]] $data = $global:data) {
    $options = 1
    for ($i = 0; $i -lt $data.Length-1; $i++) {
        if ($i -lt $data.Length-2 -and $data[$i+2]-$data[$i] -le 3) {
            $options += Get-ArrangementOptions -data $data[,$i + $($i+2)..$($data.Length-1)]
        }
    }
    return $options
}

Function Get-ArrangementOptionsEfficient ([int[]] $data = $global:data) {
    $options = 1
    $start = 0
    for($i=0; $i -lt $data.Length-1; $i++) {
        if ($data[$i+1]-$data[$i] -eq 3) {
            $options *= Get-ArrangementOptions $data[$start..$i]
            $start = $i+1
        }
    }
    return $options
}

$data = $data | Sort-Object
$data = Expand-Data $data
write-host $data
$options = Get-ArrangementOptionsEfficient $data

Write-Output "Result: $options"