# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential
$collectors

# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Get-PSSumoLogicApiCollector -Credential $credential -Id ($collectors.Id | select -First 5)