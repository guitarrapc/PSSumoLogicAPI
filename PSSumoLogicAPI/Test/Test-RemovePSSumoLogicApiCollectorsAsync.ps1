# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request")
$collectors = Get-PSSumoLogicApiCollector -Async | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Async