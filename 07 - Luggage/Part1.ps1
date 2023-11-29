Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force

$data = Get-Content .\Data.txt
$target = "shiny gold"
$testdata = Get-Content .\Testdata.txt

Function Get-Colors {
    $colors = @()
    foreach ($line in $data) {
        $array = $line.Split(" ")
        $colors += $array[0] + $array[1]
    }
    return $colors
}

Function Initialize-Rules ([string[]] $data) {
    $rules = [string[][]]::new($data.Length);
    for ($i = 0; $i -lt $data.Length; $i++) {
        $rules[$i] = New-ColorArray -line $data[$i]
    }
    return $rules
}

Function Remove-UnneccesaryInformation ([string] $line) {
    $line = $line -replace ' ?[,.] ?', ' '
    $line = $line -replace ' ?[0-9] ?', ' '
    $line = $line -replace ' ?bags? ?', ' '
    $line = $line -replace ' ?contain ?', ' '
    $line = $line.trim()
    return $line
}

Function New-ColorArray ([string] $line) {
    $line = Remove-UnneccesaryInformation -line $line
    $array = $line -split " "
    $colorArray = @()
    for ($i = 0; $i -lt $array.Length - 1; $i += 2) {
        $colorArray += $array[$i] + " " + $array[$i + 1]
    }
    return $colorArray
}

Function InnerContains ([string[]] $array, [string] $target = $global:target) {
    return $array[1..$($array.Length - 1)] -contains $target
}

Function Get-BagsContainingTarget {
    $replacements = -1
    $totalReplacements = 0
    while ($replacements -ne 0) {
        $replacements = IterateRules
        $totalReplacements += $replacements
    }
    return $totalReplacements
}

Function IterateRules {
    $colors = Get-BagsDirectlyContainingTarget -rules $global:rules
    Rename-Bags -colors $colors
    return $colors.Length
}

Function Get-BagsDirectlyContainingTarget ([string] $target = $global:target) {
    $colors = @()
    $global:rules | ForEach-Object {
        $outer = $_[0]
        if ($outer -eq $target) {
            return
        }
        if (InnerContains -array $_) {
            $colors += $outer
        }
    }
    return $colors
}

Function Rename-Bags ([string[]] $colors) {
    $colors | ForEach-Object {
        Rename-BagsSingleColor -color $_
    }
}

Function Rename-BagsSingleColor ([string] $color, [string] $target = $global:target) {
    for ($i = 0; $i -lt $global:rules.Length; $i++) {
        $global:rules[$i] = $global:rules[$i] -replace $color, $target
    }
}

$rules = Initialize-Rules -data $data

Write-Output "Bags that can contain a $target bag: $(Get-BagsContainingTarget)"
