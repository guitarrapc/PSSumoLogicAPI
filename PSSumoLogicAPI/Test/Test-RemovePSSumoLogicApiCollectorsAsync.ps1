# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Credential $credential -Async