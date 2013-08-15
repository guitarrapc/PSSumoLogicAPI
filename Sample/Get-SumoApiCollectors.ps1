$user ="Input UserName"
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


# Display Collector OS
Write-Host "Display Collectors group by osName" -ForegroundColor Cyan
$Collectors | group osName -NoElement
