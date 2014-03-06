# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector
$collectors

# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Get-PSSumoLogicApiCollector -Id ($collectors.Id | select -First 5)