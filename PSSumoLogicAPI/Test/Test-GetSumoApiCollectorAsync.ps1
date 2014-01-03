# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request for each CollectorId")
Get-PSSumoLogicApiCollector -Credential $credential -CollectorIds ($collectors.Id | select -First 5) -Async