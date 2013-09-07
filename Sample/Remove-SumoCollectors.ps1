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


# Remove Collectors
Remove-SumoApiCollectors -CollectorIds $Collectors.CollectorIds -Credential $credential

# Remove Collectors parallel
Remove-SumoApiCollectors -CollectorIds $stoppedCollectors.CollectorIds -parallel -Credential $credential


# Delete Stopped state Collectors
Write-Host "Display not alive Collectors" -ForegroundColor Cyan
$stoppedCollectors = $Collectors | %{
    [PSCustomObject]@{
        CollectorIds = $_.id
        name = $_.name
        alive = $_.alive
        osName = $_.osName
    }
} | where alive -eq $false 

Write-Host "[ $stoppedCollectors ] Stopped State Collectors." -ForegroundColor Cyan

if ($stoppedCollectors.Length -eq 0)
{
    Write-Host "0 Stopped State Colletors found. Escape remove job." -ForegroundColor Cyan
}
else
{
    if (($(Read-Host "Do you want to Delete $($stoppedCollectors.Count) stopped state collectors? (y/n)") -eq "y"))
    {
        Write-Host "Calling Sumo API to Delete Stopped State Collectors" -ForegroundColor Cyan
    
        Remove-SumoApiCollectors -CollectorIds $stoppedCollectors.CollectorIds -Credential $credential
    }
}