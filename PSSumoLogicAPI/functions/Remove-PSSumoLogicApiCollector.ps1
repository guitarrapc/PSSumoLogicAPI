#Requires -Version 3.0

# # -- Collector cmdlets -- # #

function Remove-PSSumoLogicApiCollector
{

    [CmdletBinding()]
    param
    (
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Id,

        [parameter(
            position = 1,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential),

        [parameter(
            position = 2,
            mandatory = 0)]
        [switch]
        $Async
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    }

    process
    {
        try
        {
            if ($PSBoundParameters.Async.IsPresent)
            {
                Write-Verbose "Running Async execution"
                $command = {
                    param
                    (
                        [int]$Collector,
                        [hashtable]$PSSumoLogicApi,
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collctorId -f $Collector))).uri
                    Write-Verbose -Message ("Posting Asynchronous Delete Collector Request '{0}'" -f $uri)
                    Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -ContentType $PSSumoLogicApi.contentType -Credential $Credential
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $Id -credential $Credential
            }
            else
            {
                foreach ($Collector in $Id)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collctorId-f $Collector))).uri
                    Write-Verbose -Message ("Posting Synchronous Delete Collector Request '{0}'" -f $uri)
                    Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -ContentType $PSSumoLogicApi.contentType -Credential $Credential
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}