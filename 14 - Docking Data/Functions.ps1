Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Convert-ToBinaryArray ([string] $string) {
    return [char[]][convert]::ToString($string,2).PadLeft($mask.Length,'0')
}
Function Convert-ToNumber ([char[]] $array) {
    return [convert]::ToInt64($array -join "",2)
}

Function Mask1 ([string] $string) {
    $val = Convert-ToBinaryArray -string $string
    for ($i = 0; $i -lt $mask.Length; $i++) {
        if ($mask[$i] -ne "X") {
            $val[$i] = $mask[$i]
        }
    }
    return Convert-ToNumber -array $val
}

Function FloatBit ([char[]] $address, [int] $i = 0) {
    $i0 = $i+1
    $address[$i] = '1'
    Write-Addresses -address $address -i0 $i0
    $address[$i] = '0'
    Write-Addresses -address $address -i0 $i0
}

Function Write-Addresses ([char[]] $address, [int] $i0 = 0) {
    for ($i = $i0; $i -lt $mask.Length; $i++) {
        switch ($mask[$i]) {
            1 {$address[$i] = '1'}
            'X' {
                FloatBit -address $address -i $i
            }
        }
    }
    $memory[(Convert-ToNumber -array $address)] = $value
}

Function Write-Memory2 ([string] $address, [string] $value) {
    $addressChar = Convert-ToBinaryArray -string $address
    Write-Addresses -address $addressChar
}

Function Write-Memory ([string] $line) {
    $entry = $line.Split(" = ")
    $address = $entry[0] -replace '\D'
    if ($part -eq 1) {
        $memory[$address] = Mask1 -string $entry[1]
        return
    }
    Write-Memory2 -address $address -value $entry[1]
}

Function Parse ([string] $line) {
    if ($line -Match "mask = ") {
        $global:mask = [char[]] $($line -replace "mask = ")
    } else {
        Write-Memory -line $line 
    }
}

Function Get-Result ([string] $dataName = ".\Data.txt") {
    $global:memory = @{}
    $data = Get-Content $dataName
    $i = 0
    foreach ($line in $data) {
        Parse -line $line
        $i++
        Write-Host "$i of $($data.count) complete: $mask"
    }
    return Get-Sum -array $memory.Values
}
