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
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

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
                        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                        [int]$timeoutSec,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri
                    $param = @{
                        Uri           = $uri.AbsoluteUri
                        Method        = "Delete"
                        ContentType   = $PSSumoLogicApi.contentType
                        WebSession    = $WebSession
                        timeoutSec    = $timeoutSec
                    }
                    Write-Verbose -Message ("Posting Asynchronous Delete Collector Request '{0}'" -f $uri)
                    Invoke-RestMethod @param
                }

                $asyncParam = @{
                    Command     = $command
                    CollectorId = $Id
                    WebSession  = $WebSession
                    timeoutSec  = $timeoutSec
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam
            }
            else
            {
                foreach ($Collector in $Id)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId-f $Collector))).uri
                    Write-Verbose -Message ("Posting Synchronous Delete Collector Request '{0}'" -f $uri)
                    $param = @{
                        Uri           = $uri.AbsoluteUri
                        Method        = "Delete"
                        ContentType   = $PSSumoLogicApi.contentType
                        WebSession    = $WebSession
                        timeoutSec    = $timeoutSec
                    }
                    Invoke-RestMethod @param
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}