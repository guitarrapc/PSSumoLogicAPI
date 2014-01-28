# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Asynchronize request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $_.id -Async

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id -Credential $credential -Async}