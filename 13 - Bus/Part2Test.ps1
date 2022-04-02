. $PSScriptRoot\Part2.ps1 | Out-Null

$dataName = ".\TestDataAll.txt"

[string[]] $data = Get-Content $dataName

for ($i = 1; $i -lt $data.Length; $i += 2) {
    $expected = $data[$i-1]
    $bussesWithOffset = Get-Busses $data[$i]
    $actual = ChineseRemainder -table $bussesWithOffset
    Write-Output "expected: $expected, actual: $actual"
}