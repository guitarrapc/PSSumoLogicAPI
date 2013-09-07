$user = "hoge@hoge.com"
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

# Filter Collector
$collector = $collectors `
    | where osName -eq "Windows Server 2012" `
    | where Name -like "Server*"
    
# Set Sources 
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoApiCollectorsSource -CollectorIds $Collector.id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -timeZone Asia/Tokyo -Credential $credential -parallel}
,("HelloLog","C:\logs\HelloLog.log","HelloLog Description") | %{Set-SumoApiCollectorsSource -CollectorIds $Collector.id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -timeZone Asia/Tokyo -Credential $credential -parallel}


