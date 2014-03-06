# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector | select -First 5

# Remove each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id