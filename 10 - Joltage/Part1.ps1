Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
[int[]] $data = Get-Content .\Data.txt
[int[]] $data = Get-Content .\TestData.txt

Function Expand-Data ([int[]] $data = $global:data) {
    return ,0 + $data + $($data[-1]+3)
}

Function Get-JoltageJumps ([int[]] $data = $global:data) {
    $jumps = 0,0,0
    for ($i = 1; $i -lt $data.Length; $i++) {
        $jumps[$data[$i]-$data[$i-1]-1]++
    }
    return $jumps
}

$data = $data | Sort-Object
$data = Expand-Data $data
$jumps = Get-JoltageJumps $data

Write-Output "Jumps: $jumps. Result: $($jumps[0]*$jumps[2])"