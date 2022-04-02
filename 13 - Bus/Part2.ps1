Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force
 
$dataName = ".\Data.txt"

[string[]] $data = Get-Content $dataName

Function ChineseRemainder([Hashtable] $table) {
    $Product = Product -array $table.keys
    $sum = 0
    foreach ($pair in $table.GetEnumerator()) {
        $a = -$pair.Value
        $m = $pair.Name
        $Mi = $Product/$m
        $s = ExtendedEuclidean -m $Mi -n $m
        $e = $s*$Mi
        $sum += $a*$e
    }
    $sum %= $Product
    if ($sum -lt 0) {
        $sum += $Product
    }
    return $sum
}
Function ExtendedEuclidean([int64] $m, [int64] $n, [int64] $s = 1, [int64] $t = 0, [int64] $u = 0, [int64] $v = 1) {
    $q = [math]::floor($m/$n);
    $r = $m - $q*$n;
    if ($r -eq 0) {
        return $u
    }
    $u_ = $s-$q*$u
    $v_ = $t-$q*$v
    ExtendedEuclidean -m $n -n $r -s $u -t $v -u $u_ -v $v_
}

Function Get-Busses ([string] $busses) {
    $allBusses = $busses -split ","
    $activeBusses = @{}
    for ($i = 0; $i -lt $allBusses.Length; $i++) {
        if ($allBusses[$i] -match '^\d+$') {
            $activeBusses[[int64] $allBusses[$i]] = $i
        }
    }
    return $activeBusses
}

$bussesWithOffset = Get-Busses $data[1]
$res = ChineseRemainder -table $bussesWithOffset
$bussesWithOffset
Write-Output $res