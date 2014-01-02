# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Remove-PSSumoLogicApiCollectors -CollectorIds $Collectors.id -Credential $credential