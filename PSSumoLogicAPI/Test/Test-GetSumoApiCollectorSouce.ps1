# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $collectors.id

