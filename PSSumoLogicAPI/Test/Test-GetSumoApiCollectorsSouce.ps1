# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $collectors.id

