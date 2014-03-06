# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Session Variables
$host.Ui.WriteVerboseLine("Get Sessionvariables and PassThru")
Get-PSSumoLogicApiWebSession -PassThru

$host.Ui.WriteVerboseLine("Output whether session contains in PSSumoLogicAPI variable.")
$PSSumoLogicAPI.WebSession
