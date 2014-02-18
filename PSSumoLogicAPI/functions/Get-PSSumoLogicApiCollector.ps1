#Requires -Version 3.0

# # -- Collector cmdlets -- # #

function Get-PSSumoLogicApiCollector
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
        [int[]]
        $Id = $null,

        [parameter(
            position = 1,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-PSSumoLogicApiCredential),

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
            if ($null -eq $Id)
            {
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, $PSSumoLogicAPI.uri.collector)).uri
                (Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential).collectors
            }
            else
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
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri
                        Write-Verbose -Message ("Sending Asynchronous Get Collector Request '{0}'" -f $uri)
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5
                    }                                
                    Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $Id -credential $Credential
                }
                else
                {
                    foreach ($Collector in $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri
                        Write-Verbose -Message ("Sending Synchronous Get Collector Request '{0}'" -f $uri)
                        (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5).Collector
                    }
                }
            }
        
        }
        catch [System.Management.Automation.ActionPreferenceStopException]
        {
            switch ($_.Exception)
            {
                [System.Net.WebException] {throw $_.Exception}
                default                   {throw $_}
            }
        }
    }
}