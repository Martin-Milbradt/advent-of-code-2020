Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Get-Result ([string] $data) {
    $lastOccurence = , -1*$target
    $occured = , $false*$target
    $startingNumbers = $data.Split(",")
    for ($i = 0; $i -lt $startingNumbers.length-1; $i++) {
        $lastOccurence[$startingNumbers[$i]] = $i
        $occured[$startingNumbers[$i]] = $true
    }
    $lastNumber = $startingNumbers[$i]
    for ($i; $i -lt $target-1; $i++) {
        if ($i % 10000 -eq 0) {
            Write-Progress -Activity "Counting" -Status "$i Complete:" -PercentComplete ($i/$target*100)
        }
        if ($occured[$lastNumber]) {
            $Number = $i - $lastOccurence[$lastNumber]
            $lastOccurence[$lastNumber] = $i
            $lastNumber = $Number
        } else {
            $occured[$lastNumber] = $true
            $lastOccurence[$lastNumber] = $i
            $lastNumber = 0
        }
    }
    return $lastNumber
}
