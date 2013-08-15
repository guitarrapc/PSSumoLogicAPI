$user ="Input UserName"
$credential = Get-SumoCredential -User $user -force

$Collectors = Get-SumoApiCollectors -Credential $credential

$sets = @(
    ("LogName","LogPath","Desctiption"),
    ("LogName","LogPath","Desctiption")
)

$jsons = $sets `
    | %{ @{ 
        source = @{ 
            pathExpression = $_[1]
            name = $_[0]
            sourceType = "LocalFile"
            category = $_[0]
            description = $_[2]
            alive = $true
            states = ""
            automaticDateParsing = $true
            timeZonne = "Asia/Tokyo"
            multilineProcessingEnabled = $true
        }} ` | ConvertTo-Json
        }


$osName = "Windows Server 2012"
$name = "hogehoge*"

$collectors `
    | where osName -eq $osName `
    | where Name -like $name `
    | %{
    try
    {
        foreach ($json in $jsons)
        {
            Invoke-RestMethod -Method Post -Uri "https://api.sumologic.com/api/v1/collectors/$($_.id)/sources/" -Credential $cred -ContentType "application/json" -Body $json -ErrorAction Stop
        }
    
    }
    catch
    {
        throw $_
    }

}
