$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | Select -First 2

# Set Sources
$host.Ui.WriteVerboseLine("Running Asynchronize request to set sources")
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorIds $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential -Async}

