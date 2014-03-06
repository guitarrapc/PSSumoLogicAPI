# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollector | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronous request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Async