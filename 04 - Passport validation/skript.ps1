Push-Location $PSScriptRoot

$data = Get-Content .\Data.txt
$fields = "byr:", "iyr:", "eyr:", "hgt:", "hcl:", "ecl:", "pid:"
$validations = 'Validation-Byr', 'Validation-iyr', 'Validation-Eyr', 'Validation-Hgt', 'Validation-Hcl', 'Validation-Ecl', 'Validation-Pid'

$ecls = "amb", "blu", "brn", "gry", "grn", "hzl", "oth"

$OoR = ""
$NaN = ""

Function Validate-Date([string] $field, [int] $min, [int] $max) {
    if ($line -match "$field\:([0-9]+)") {
        [int] $yr = $Matches[1]
        if ($yr -ge $min -and $yr -le $max) {
            return $true
        }
        else {
            $global:OoR += "Year " + $field + ":" + $yr + " out of range " + $min + "-" + $max +" in line " + $line + "`n"
            return $false
        }
    }
    $global:NaN += "Year " + $field + " is not a number in line " + $line + "`n"
    return $false
}

Function Validate-Height([string] $unit, [int] $min, [int] $max) {
    if ($line -match "([0-9]+)$unit") {
        [int] $hgt = $Matches[1]
        if ($hgt -ge $min -and $hgt -le $max) {
            return $true
        }
        else {
            $global:OoR += "Height " + $hgt + $unit + " out of range " + $min + "-" + $max + $unit + " in line " + $line + "`n"
            return $false
        }
    }
    return $false
}

Function Validation-Byr([string] $line) {
    return Validate-Date -field "byr" -min 1920 -max 2002
}

Function Validation-Iyr([string] $line) {
    return Validate-Date -field "iyr" -min 2010 -max 2020
}

Function Validation-Eyr([string] $line) {
    return Validate-Date -field "eyr" -min 2020 -max 2030
}

Function Validation-Hgt([string] $line) {
    if ($(Validate-Height -unit "cm" -min 150 -max 193) -or $(Validate-Height -unit "in" -min 59 -max 76))
    {
        return $true
    }
    return $false
}

Function Validation-Hcl([string] $line) {
    if ($line -match 'hcl:#[0-9a-f]{6} ') {
        return $true
    }
    $global:NaN += "Hair color ist not a 6-digit hexadecimal number with a leading # in " + $line + "`n"
    return $false
}

Function Validation-Ecl([string] $line) {
    if ($line -match 'ecl:([a-z]{3}) ') {
        $ecl = $Matches[1]
        ForEach($cl in $ecls) {
            if($ecl -eq $cl) {
                return $true
            }
        }
        $global:OoR += "Eye color " + $ecl + " out of range (" + $ecls + ") in line " + $line + "`n"
        return $false
    }
    $global:NaN += "Hair color is not a 3-letter-string in line " + $line + "`n"
    return $false
}

Function Validation-Pid([string] $line) {
    if ($line -match 'pid:[0-9]{9} ') {
        return $true
    }
    $global:NaN += "Pid is not a 9 digit number in " + $line + "`n"
    return $false
}

Function Parse-Data {
    $newData = ,""
    foreach ($line in $data) {
        if ($line -eq "") {
            $newData += ""
        }
        else {
            $newData[-1] += $line + " "
        }
    }
    return $newData
}

Function Check-Contains([string] $line) {
    foreach ($field in $fields)
    {
        if ($line -notmatch $field) {
            return $false
        }
    }
    return $true
}

Function Check-Line([string] $line) {
    if (-not (Check-Contains -line $line)) {
        return $false
    }
    foreach ($func in $validations)
    {
        if (-not(& $func -line $line)) {
            return $false
        }
    }
    return $true
}

Function Check-Data {
    $valid = 0
    foreach ($line in $data) {
        
        if (Check-Line -line $line) {
            $valid ++
        }
    }
    return $valid
}

$data = Parse-Data

Write-Host $(Check-Data)
$OoR
$NaN