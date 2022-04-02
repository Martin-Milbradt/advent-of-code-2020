Push-Location $PSScriptRoot

$data = Get-Content .\Data.txt 

Function ParseAll() {
    $valid = 0
    foreach ($pw in $data) {
        if (IsValid -pw $pw) {
            $valid++
        }
    }
    return $valid
}

Function IsValid([string] $pwString) {
    $pwArr = $pwString.Split("-").Split(" ").Split(":")
    return PlaceValidation -first $pwArr[0] -second $pwArr[1] -char $pwArr[2] -pw $pwArr[4]
    #return OccurenceValidation -min $pwArr[0] -max $pwArr[1] -char $pwArr[2] -pw $pwArr[4]
}

Function PlaceValidation([int] $first, [int] $second, [string] $char, [string] $pw) {
    $eqFirst = $pw.Substring($first-1, 1) -eq $char
    $eqSecond = $pw.Substring($second-1, 1) -eq $char
    if ($eqFirst -xor $eqSecond) {
        $isValid = $true
    }
    return $isValid
}

Function OccurenceValidation([int] $min, [int] $max, [string] $char, [string] $pw) {
    $occ = Occurences -text $pw -char $char
    if ($occ -le $max -and $occ -ge $min) {
        $isValid = $true
    }
    return $isValid
}

Function Occurences([string] $text, [string] $char) {
    return $text.Split($char).Length - 1
}

Write-Output $(ParseAll)


