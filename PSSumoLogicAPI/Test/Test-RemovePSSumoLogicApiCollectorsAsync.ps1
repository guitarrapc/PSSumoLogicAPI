# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId")
Remove-PSSumoLogicApiCollectors -CollectorIds $Collectors.id -Credential $credential -Async