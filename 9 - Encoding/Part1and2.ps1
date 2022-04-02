Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$data = Get-Content .\Data.txt
$length = 25

#$data = Get-Content .\Testdata.txt
#$length = 5

Function Get-FirstFalseNumber ([decimal[]] $data = $global:data, [int] $length = $global:length) {
    for ($i = $length; $i -lt $data.Length; $i++) {
        if (-not(Test-SumOfTwo -target $data[$i] -numbers $data[$($i-$length)..$($i-1)])) {
            return $data[$i]
        }
    }
}

Function Get-SummationChain ([decimal] $target, [decimal[]] $data = $global:data) {
    $sum = 0
    $start = 0
    for ($i = 0; $sum -lt $target; $i++) {
        $sum += $data[$i]
        Write-Host "Summe: $sum, First: $($data[$start]) $start Last: $($data[$i]) $i"
        if ($i -gt $data.Length) {break}
        while ($sum -gt $target) {
                $sum -= $data[$start]
                $start++
                Write-Host "Summe: $sum, First: $($data[$start]) $start Last: $($data[$i]) $i"
        }
    }
    return $start, $($i-1)
}
Function Get-Weakness  ([decimal[]] $data = $global:data, [int] $start = 0, [int] $end = $global:data.Length) {
    $min = $data[$start]
    $max = $data[$end]
    $data[$($start+1)..$end] | ForEach-Object {
        if ($_ -lt $min) {
            $min = $_
            return
        }
        if ($_ -gt $max) {
            $max = $_
        }
    }
    return $min + $max
}

$firstError = Get-FirstFalseNumber -data $data -length $length
$start, $end = Get-SummationChain  -data $data -target $firstError
$weakness = Get-Weakness -data $data -start $start -end $end
Write-Output "First false number: $firstError"
Write-Output "The numbers from $start to $end sum up to it. The encryption weakness is $weakness."