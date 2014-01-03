#Requires -Version 3.0

# # -- Collector cmdlets -- # #

function Get-PSSumoLogicApiCollector
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [int[]]
        $CollectorIds = $null,

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

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference
    
    try
    {
        if ($null -eq $CollectorIds)
        {
            [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, $PSSumoLogicAPI.uri.collector)).uri
            $Collectors = Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential
            $Collectors.collectors
        }
        else
        {
            if ($PSBoundParameters.Async.IsPresent)
            {
                Write-Verbose "Running Async execution"
                $command = {
                    param
                    (
                        [int]$CollectorId,
                        [hashtable]$PSSumoLogicApi,
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $CollectorId))).uri
                    Write-Verbose -Message "Sending Get source Request to $uri"
                    $result = Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential
                    $result
                }
                                
                Write-Verbose -Message "Sending Get Collector Rquest to $uri"
                Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorIds $CollectorIds -credential $Credential
            }
            else # not Async Invokation
            {
                foreach ($CollectorId in $CollectorIds)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $CollectorId))).uri
                    Write-Verbose -Message "Sending Get Collector Request to $uri"
                    (Invoke-RestMethod -Uri $uri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential).Collector
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