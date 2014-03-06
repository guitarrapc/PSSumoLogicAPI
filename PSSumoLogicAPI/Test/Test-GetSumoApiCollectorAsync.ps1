# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Verbose

# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Asynchronous request for each CollectorId")
Get-PSSumoLogicApiCollector -Id ($collectors.Id | select -First 5) -Async -Verbose