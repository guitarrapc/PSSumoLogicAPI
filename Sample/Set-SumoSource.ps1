$user ="Input UserName"
$credential = Get-SumoCredential -User $user -force

$Collectors = Get-SumoApiCollectors -Credential $credential
$Collector = $Collectors | where name -eq 'hogehoge'

# Create Sumo Json Format


$json = @{ 
    source = @{ 
        pathExpression = "Input Path of Log"
        name = "test"
        sourceType = "LocalFile"
        category = "test"
        alive = $true
        states = ""
    }
} | ConvertTo-Json


# SingSet

try
{
    Invoke-RestMethod -Method Post -Uri "https://api.sumologic.com/api/v1/collectors/$($Collector.id)/sources/" -Credential $cred -ContentType "application/json" -Body $json -ErrorAction Stop
    
}
catch
{
    throw $_
}
#>