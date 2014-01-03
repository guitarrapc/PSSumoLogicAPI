# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $_.id

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorIds $_.id -SourceIds $souces.id -Credential $credential}