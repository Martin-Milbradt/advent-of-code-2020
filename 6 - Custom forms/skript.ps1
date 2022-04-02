Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Verbose -Force
 
$data = Get-Content .\Data.txt
$data = $(Convert-NewlineData -data $data)
$allLetters = 'a'..'z'

Function Get-Letters([string] $line, [string[]] $letters) {
    $contained = @()
    $letters | ForEach-Object { 
        if ($line -match $_) {
            $contained += $_
        }
    }
    return $contained
}

Function Get-NumberOfSingleYes([string] $line, [char[]] $letters = $allLetters) {
    return $(Get-Letters -line $line -letters $letters).Length
}

Function Get-NumberOfAllYes([string] $line) {
    $answers = $line -split " "
    $letters = $answers[0].ToCharArray()
    for($i = 1; $i -lt $answers.Length; $i++) {
        $letters = Get-Letters -line $answers[$i] -letters $letters
        if ($letters.Length -eq 0) {
            break
        }
    }
    return $letters.Count
}

Function Get-YesFromData([string] $function) {
    [int] $yesTotal = 0
    foreach ($line in $data) {
        $yesTotal += & $function -line $line
    }
    return $yesTotal
}

Function Part1 {
    $yes = Get-YesFromData -function 'Get-NumberOfSingleYes'
    Write-Host $yes
}
Function Part2 {
    $yes = Get-YesFromData -function 'Get-NumberOfAllYes'
    Write-Host $yes
}

Part1
Part2