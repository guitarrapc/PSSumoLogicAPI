# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential
$collectors

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Get-PSSumoLogicApiCollectors -Credential $credential -CollectorIds ($collectors.Id | select -First 5)

