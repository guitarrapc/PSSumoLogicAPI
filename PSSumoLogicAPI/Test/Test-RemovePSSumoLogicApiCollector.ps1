# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 5

# Remove each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -CollectorIds $Collectors.id -Credential $credential