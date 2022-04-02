Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function CreateArray ([int[]] $numbers) {
    $array = @(-1)*$target;
    for ($i = 0; $i -lt $numbers.length; $i++) {
        $array[$i] = $numbers[$i]
    }
    return $array
}

Function Get-Result ([string] $data) {
    $startingNumbers = $data.Split(",")
    $array = CreateArray -numbers $startingNumbers
    $lastOccurence = @{}
    for ($i = 0; $i -lt $startingNumbers.length-1; $i++) {
        $lastOccurence[$array[$i]] = $i
    }
    for ($i; $i -lt $array.length-1; $i++) {
        Write-Progress -Activity "Counting" -Status "$i Complete:" -PercentComplete ($i/$target*100)
        if ($lastOccurence.Keys -contains $array[$i]) {
            $array[$i+1] = $i - $lastOccurence[$array[$i]]
        } else {
        $array[$i+1] = 0
        }
        $lastOccurence[$array[$i]] = $i
    }
    return $array[-1]
}
