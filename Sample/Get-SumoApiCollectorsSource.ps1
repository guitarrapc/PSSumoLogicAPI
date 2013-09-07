# define
$user = "hoge@hoge.com"

# Get Credential
$credential = Get-SumoCredential -User $user -force


# Obtain Collectors
if (($collectors.Length -ne $null) -and ($(Read-Host "Do you want to get new collectors? (y/n)") -eq "y"))
{
    Write-Verbose "Calling Sumo API to get current Collectors"
    $Collectors = Get-SumoApiCollectors -Credential $credential

    Write-Host "Now you have $($collectors.count) collectors objects." -ForegroundColor Cyan
}
else
{
    Write-Host "Using existing colletors. skip Get-SumoApiCollectors." -ForegroundColor Cyan
}

# All
Get-SumoApiCollectorsSource -CollectorIds $collectors.Id -Credential $credential

# Parallel
Get-SumoApiCollectorsSource  -Credential $credential -CollectorIds $Collectors.id -parallel

# Selected collector
Get-SumoApiCollectorsSource -CollectorIds $($collectors | where Id -eq 3434151).Id -Credential $credential

