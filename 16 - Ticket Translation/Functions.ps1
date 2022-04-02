Push-Location $PSScriptRoot
$ParentFolder = (get-item $PSScriptRoot).parent.FullName
Import-Module -name "$ParentFolder\Modules\modules.psm1" -Force

Function Parse([string[]] $data) {
    $rules = @{}
    for ($i = 0; $data[$i] -ne ""; $i++) {
        $rule = $data[$i].Split(": ")
        $field = $rule[0]
        $ranges = $rule[1].Split("-").Split(" or ")
        $rules[$field] = $ranges
    }
    $i+=2
    $myTicket = $data[$i].Split(",")
    $nearbyTickets = @()
    for ($i+=3; $i -lt $data.Length; $i++) {
        $nearbyTickets += , $data[$i].Split(",")
    }
    return @($rules, $myTicket, $nearbyTickets)
}

Function FulfillsRule ([int[]] $rule, [int] $value) {
    for ($i = 0; $i -lt $rule.Length-1; $i++) {
        if ($rule[$i] -le $value -and $value -le $rule[++$i]) {
            return $true
        }
    }
    return $false
}

Function Get-ValueOfViolation ([int] $value) {
    foreach ($rule in $rules.values) {
        if (FulfillsRule -rule $rule -value $value) {
            return 0
        }
    }
    return $value
}

Function Get-ValueOfViolations ([int[]] $ticket) {
    $sum = 0
    $ticket | ForEach-Object {
        $sum += Get-ValueOfViolation -value $_
    }
    return $sum
}

Function Get-Result ([string] $dataName = ".\Data.txt") {
    [string[]] $data = Get-Content $dataName
    $global:validTickets = @()
    $global:rules, $myTicket, $nearbyTickets = Parse -data $data
    $sum = 0
    $nearbyTickets | ForEach-Object {
        $value = Get-ValueOfViolations -ticket $_
        $sum += $value
        if ($part -eq 2 -and $value -eq 0) {
            $global:validTickets += , $_
        }
    }
    if ($part -eq 1) {
        return $sum
    }

}
