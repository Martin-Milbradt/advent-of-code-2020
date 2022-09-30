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

Function Remove-Fields ($fields, [string] $name) {
    foreach ($field in $fields) {
        $null = $field.Remove($name)
    }
    return $fields
}

Function Get-Fields ($possibleFields, [string[]] $fields = $null) {
    $count = $possibleFields.Count
    if ($null -eq $fields) {
        $foundCount = 0
        $fields = New-Object String[] $count
    } else {
        $foundCount = $($fields | Where-Object {$null -ne $_}).count
    }
    while ($true) {
        $foundCountOld = $foundCount
        do {
            $found = $false
            for ($i = 0; $i -lt $count; $i++) {
                # no option
                if($possibleFields[$i].Count -eq 0 -and $null -eq $fields[$i]) {
                    return $false
                }
                # only option
                if($possibleFields[$i].Count -eq 1) {
                    $foundCount++
                    $found = $true
                    $fields[$i] = $possibleFields[$i]
                    $possibleFields = Remove-Fields -fields $possibleFields -name $possibleFields[$i]
                }
            }
        } While ($found -eq $true)
        do {
            $found = $false
            $occurences = $(Flatten -object $possibleFields)
            $grouped = $occurences | Group-Object | Sort-Object -Property Count
            if ($grouped.Count -eq 0) {
                return $fields
            }
            # only occurence of name
            for ($i = 0; $grouped[$i].Count -eq 1; $i++) {
                $found = $true
                $foundCount++
                for ($j = 0; $j -lt $count; $j++) {
                    $name = $grouped[$i].Name
                    if ($possibleFields[$j] -eq $name) {
                        $fields[$j] = $name
                        $possibleFields[$j] = New-Object Collections.Generic.List[String]
                        break
                    }
                }
            }
        } while ($found -eq $true)
        # nothing found: guess / eliminate
        if ($foundCountOld -eq $foundCount) {
            $possibleFieldsCandidate = $possibleFields
            $name = $grouped[0].Name
            for ($j = 0; $j -lt $count; $j++) {
                if ($possibleFieldsCandidate[$j].Contains($name)) {
                    $possibleFieldsCandidate[$j] = New-Object Collections.Generic.List[String]
                    $possibleFieldsCandidate[$j].Add($name)
                    break
                }
            }
            $fieldsCandidate = Get-Fields -possibleFields $possibleFieldsCandidate -fields $fields
            if ($possibleFieldsCandidate -eq $false) {
                $possibleFields[$j].Remove($name)
            } else {
                return $fieldsCandidate
            }
        }
    }
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
    $fields = Get-Fields -possibleFields $possibleFields
    $prod = 1;
    for ($i = 0; $i -lt $fields.Count; $i++) {
        if ($fields[$i].StartsWith("departure")) {
            $prod *= $myTicket[$i]
        }
    }
    return $prod
}

Function Get-Result ([string] $dataName, [int] $part = $global:part) {
    if ($part -eq 1) {
        return Get-Part1 -dataName $dataName
    }
    return Get-Part2 -dataName $dataName
}