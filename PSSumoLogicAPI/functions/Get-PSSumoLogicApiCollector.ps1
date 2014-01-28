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
                        Write-Verbose -Message "Sending Get source Request to $uri"
                        if ($PSVersionTable.PSVersion.Major -ge "4")
                        {
                            Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential
                        }
                        else
                        {
                            Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -Credential $Credential
                        }
                    }
                                
                    Write-Verbose -Message "Sending Get Collector Rquest to $uri"
                    Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $Id -credential $Credential
                }
                else
                {
                    foreach ($Collector in $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collectorId -f $Collector))).uri
                        Write-Verbose -Message "Sending Get Collector Request to $uri"
                        if ($PSVersionTable.PSVersion.Major -ge "4")
                        {
                            (Invoke-RestMethod -Uri $uri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential).Collector
                        }
                        else
                        {
                            (Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential).Collector
                        }
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