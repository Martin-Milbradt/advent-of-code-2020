Function Convert-NewlineData {
    param(
        [string[]] $data
    )

    $newData = ,""
    foreach ($line in $data) {
        if ($line -eq "") {
            $newData[-1] =  $newData[-1].Trim()
            $newData += ""
        }
        else {
            $newData[-1] += $line + " "
        }
    }
    $newData[-1] = $newData[-1].Trim()
    return $newData
}

Function Get-ContentAsMatrix {
    param(
        [string] $path
    )
    $data = Get-Content $path
    return Convert-ToMatrix -data $data
}

Function Convert-ToMatrix {
    param(
        [object[]] $data
    )
    for ($i = 0; $i -lt $data.Count; $i++) {
        $data[$i] = $data[$i].Split(" ")
    }
    return $data
}

Function Out-WithLinebreaks {
    param(
        [string[]] $data
    )
    foreach ($line in $data) {
        Write-Output $line
    }
}
Function Test-SumOfTwo ([int] $target, [int[]] $numbers) {
    $numbers = $numbers | Sort-Object
    $initialI = -1;
    foreach ($number in $numbers) {
        for ($i = $initialI; $i -gt ($numbers.Length * -1); $i--) {
            switch ($number + $numbers[$i]) {
                {$_ -gt $target} {
                    $initialI--
                    continue
                }
                $target {
                    return $true
                }
                default{break}
            }
        }
    }
    return $false
}

Function Add-PaddingToMatrix {
    param(
        [object[][]] $data
    )
    for ($i=0; $i -lt $data.Length; $i++) {
        $data[$i] = ,$null + $data[$i] + $null
    }
    [Char[]] $paddingLine = New-Object object[] $data[0].Length
    $data = ,$paddingLine + $data
    return $data + ,$paddingLine
}

Function Add-PaddingToArray {
    param(
        [string[]] $data
    )
    for ($i=0; $i -lt $data.Length; $i++) {
        $data[$i] = " $($data[$i]) "
    }
    $paddingLine = " " * $data[0].Length
    return ,$paddingLine + $data + $paddingLine
}

Function Get-Deepcopy {
    param(
        $obj
    )
    $serialObj = [System.Management.Automation.PSSerializer]::Serialize($obj)
    return [System.Management.Automation.PSSerializer]::Deserialize($serialObj)
}
Function Assert-ContentEquals {
    param(
        $expected,
        $actual
    )
    return [System.Management.Automation.PSSerializer]::Serialize($actual) -eq [System.Management.Automation.PSSerializer]::Serialize($expected)
}

Function Get-Occurences {
    param(
        [string] $text,
        [string] $character
    )
    return $text.Split($character).Length - 1
}

Function Flatten ($object) {
    return @($object | ForEach-Object {$_})
}

Function Get-OccurencesArray {
    param(
        [string[]] $data,
        [string] $character
    )
    $occurences = 0
    $data | ForEach-Object {
        $occurences += Get-Occurences -text $_ -character $character
    }
    return $occurences
}
Function Get-Product([int64[]] $array) {
    $product = 1
    $array | ForEach-Object { $product *= $_ }
    return $product
}

Function Get-Sum([int64[]] $array) {
    $sum = 0
    $array | ForEach-Object { $sum += $_ }
    return $sum
}

Function Assert-Equals ($expected = $null, $actual) {
    if ($null -eq $expected) {
        return "Expected: -, Actual: $actual"
    }
    if ($expected -ne $actual) {
        return "Expected: $expected, Actual: $actual"
    }
    return "Success: $actual"
}

Export-ModuleMember -Function Test-SumOfTwo
Export-ModuleMember -Function Get-ContentAsMatrix
Export-ModuleMember -Function Convert-ToMatrix
Export-ModuleMember -Function Convert-NewlineData
Export-ModuleMember -Function Out-WithLinebreaks
Export-ModuleMember -Function Add-PaddingToArray
Export-ModuleMember -Function Add-PaddingToMatrix
Export-ModuleMember -Function Get-Deepcopy
Export-ModuleMember -Function Assert-ContentEquals
Export-ModuleMember -Function Get-Occurences
Export-ModuleMember -Function Get-OccurencesArray
Export-ModuleMember -Function Get-Product
Export-ModuleMember -Function Get-Sum
Export-ModuleMember -Function Assert-Equals
Export-ModuleMember -Function Flatten