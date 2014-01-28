# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $collectors.id -Async

