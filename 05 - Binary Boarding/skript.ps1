Push-Location $PSScriptRoot

$data = Get-Content .\Data.txt
$length = $data[0].Length
$maxLine = ""

Function Get-SeatId([string] $line) {
    $id = 0
    for ($i = 0; $i -lt $length; $i++) {
        if ($line[$i] -eq "R" -or $line[$i] -eq "B") {
            $id += [math]::Pow(2, $length - $i - 1)
        }
    }
    return $id
}

Function Get-MaxSeatId {
    $max = 0
    foreach ($line in $data) {
        $id = Get-SeatId -line $line
        if ($id -gt $max) {
            $max = $id
            $global:maxLine = $line
        }
    }
    return $max
}

Function Get-Ids {
    $ids = @()
    foreach ($line in $data) {
        $ids += Get-SeatId -line $line
    }
    $ids | sort
}

Function Find-Missing([int[]] $array) {
    for ($i = 0; $i -lt $array.Count; $i++) {
        $expected = $array[$i] + 1
        if ($array[$i + 1] -ne $expected) {
            return $expected
        }
    }
}

Write-Host $(Get-MaxSeatId)
$ids = Get-Ids
Write-Host $(Find-Missing -array $ids)
