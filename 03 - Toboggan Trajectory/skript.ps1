Push-Location $PSScriptRoot

$data = Get-Content .\Data.txt

$length = $data[0].Trim().Length
$heigth = $data.Length

Function Move-Pos([int] $right, [int] $down) {
    $global:row += $right
    $global:row %= $length
    $global:line += $down
    if ($line -ge $heigth) {
        return $true
    }
    return $false
}

Function Plot-Pos() {
    $lineData = $data[$line]
    return $lineData.remove($row, 1).insert($row, "X")
}

Function Traverse-Slope ([int] $right, [int] $down) {
    $hits = 0
    $global:line = 0;
    $global:row = 0;
    $finished = $false
    while ($finished -eq $false) {
        if ($data[$line][$row] -eq "#") {
            $hits ++
        }
        $finished = Move-Pos -right $right -down $down
    }
    return $hits
}

$trees = @();
$trees += Traverse-Slope -right 1 -down 1
$trees += Traverse-Slope -right 3 -down 1
$trees += Traverse-Slope -right 5 -down 1
$trees += Traverse-Slope -right 7 -down 1
$trees += Traverse-Slope -right 1 -down 2

$product = 1
foreach ($p in $trees) {
    $product *= $p
}

Write-Host $(Traverse-Slope -right 3 -down 1)
Write-Host $product
