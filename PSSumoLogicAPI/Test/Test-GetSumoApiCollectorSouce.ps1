# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Get Websession for authorized Cookie
Get-PSSumoLogicApiWebSession -Credential $credential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -CollectorId $collectors.id -Verbose