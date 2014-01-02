$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential | Select -First 2

# Set Sources
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorIds $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential -Async}

