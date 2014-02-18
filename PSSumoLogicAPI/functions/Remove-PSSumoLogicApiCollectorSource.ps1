#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Remove-PSSumoLogicApiCollectorSource
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
        $CollectorId,

        # Inpurt SourceId
        [parameter(
            position = 1,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $Id = $null,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-PSSumoLogicApiCredential),

        [parameter(
            position = 3,
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
                        [int]$Source,
                        [hashtable]$PSSumoLogicApi,
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                    Write-Verbose -Message ("Posting Asynchronous Delete Source for Collector Request '{0}'" -f $uri)
                    Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5
                }
                Invoke-PSSumoLogicApiInvokeCollectorSourceAsync -Command $command -CollectorId $CollectorId -SourceId $Id -credential $Credential
            }
            else # not Async Invokation
            {
                foreach ($Collector in $CollectorId)
                {
                    foreach ($Source in $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                        Write-Verbose -Message ("Posting Synchronous Delete Source for Collector Request '{0}'" -f $uri)
                        (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5).source

                        $count++
                        Write-Verbose $count
                        if ($count % 5 -eq 0)
                        {
                            $sleep = 60
                            "Sleep for {0} sec to avoid API limnits." -f $sleep
                            sleep -Seconds $sleep
                        }
                    }
                }
            }
        }
        catch
        {
            throw $_
        }
    }
}
