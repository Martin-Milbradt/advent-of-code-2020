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

Function Get-PossibleFields ([int[][]] $tickets) {
    $names = [string[]]$global:rules.Keys
    $possibleNames = New-Object Collections.Generic.List[String][] $names.Count
    foreach ($list in $possibleNames) {
        $list = New-Object Collections.Generic.List[String]
    }
    foreach ($name in $names) {
        for ($i = 0; $i -lt $tickets[0].Length; $i++) {
            if (TicketsFulfillRule -tickets $tickets -index $i -rule $rules[$name]) {
                $possibleNames[$i] += ,$name
            }
        }
    }
    return $possibleNames
}

Function TicketsFulfillRule ([int[][]] $tickets, [int] $index, [int[]] $rule) {
    foreach ($ticket in $tickets) {
        if (!(FulfillsRule -rule $rule -value $ticket[$index])) {
            return $false;
        }
    }
    return $true
}

Function Get-Fields ($possibleFields) {
    $count = $possibleFields.Count
    $fields = New-Object String[] $count
    for ($found = 0; $found -lt $count; $found++) {
        for ($i = 0; $i -lt $count; $i++) {
            if($possibleFields[$i].Count -eq 1) {
                $result = $possibleFields[$i]
                $fields[$i] = $result
                for ($j = 0; $j -lt $count; $j++) {
                    $possibleFields[$j].Remove($fields[$i])
                }
                break;
            }
        }
    }
    return $fields
}

Function Get-Part1 ([string] $dataName = ".\Data.txt") {

    [string[]] $data = Get-Content $dataName
    $global:rules, $myTicket, $nearbyTickets = Parse -data $data
    $sum = 0
    $nearbyTickets | ForEach-Object {
        $sum += Get-ValueOfViolations -ticket $_
    }
    return $sum
}

Function Get-Part2 ([string] $dataName = ".\ValidTickets.txt") {
    [string[]] $data = Get-Content $dataName
    $global:rules, $myTicket, $validTickets = Parse -data $data
    $possibleFields = Get-PossibleFields -tickets $validTickets
    return Get-Fields -possibleFields $possibleFields
}

Function Get-Result ([string] $dataName, [int] $part = $global:part) {
    if ($part -eq 1) {
        return Get-Part1 -dataName $dataName
    }
    return Get-Part2 -dataName $dataName
}