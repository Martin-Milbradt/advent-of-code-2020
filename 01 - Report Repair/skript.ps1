Push-Location $PSScriptRoot
[int[]] $data = Get-Content .\Data.txt
$data = $data | sort

Write-Output $(Calculate -target 2020 -numbers $data)
Write-Output $(Calculate-Recursion -target 2020 -numbers $data)

Function Calculate-Recursion([int] $target, [int[]] $numbers) {
    foreach ($number in $numbers) {
        $numbersWithoutNumber = $data | Where-Object { $_ –ne $number }
        $result = Calculate -target $($target - $number) -numbers $numbersWithoutNumber
        if ($result -gt -1) {
            return $result * $number
        }
    }
}

Function Calculate([int] $target, [int[]] $numbers) {
    $initialI = -1;
    foreach ($number in $numbers) {
        for ($i = $initialI; $i -gt ($numbers.Length * -1); $i--) {
            switch ($number + $numbers[$i]) {
                {$_ -gt $target} {
                    $initialI--
                    continue
                }
                $target {
                    return $number * $numbers[$i]
                }
                default{break}
            }
        }
    }
    return -1
}
