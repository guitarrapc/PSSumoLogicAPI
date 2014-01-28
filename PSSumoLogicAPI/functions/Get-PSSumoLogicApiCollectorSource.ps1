#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Get-PSSumoLogicApiCollectorSource
{
    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorIds,

        [parameter(
            position = 1,
            mandatory = 0)]
        [int[]]
        $SourceIds = $null,

        [parameter(
            position = 2,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential),

        [parameter(
            position = 3,
            mandatory = 0)]
        [switch]
        $Async
    )

    try
    {
        if ($PSBoundParameters.Async.IsPresent)
        {
            Write-Verbose "Running Async execution"
            if ($null -eq $SourceIds)
            {
                $command = {
                    param
                    (
                        [int]$CollectorId,
                        [hashtable]$PSSumoLogicApi,
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $CollectorId))).uri
                    Write-Verbose -Message "Sending Get source Request to $uri"
                    $result = if ($PSVersionTable.PSVersion.Major -ge "4")
                    {
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential
                    }
                    else
                    {
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -Credential $Credential
                    }
                    $result
                }
                                
                Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorIds $CollectorIds -credential $Credential
            }
            else
            {
                $command = {
                    param
                    (
                        [int]$CollectorId,
                        [int]$SourceId,
                        [hashtable]$PSSumoLogicApi,
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$verbose
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $CollectorId, $SourceId))).uri
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

                Invoke-PSSumoLogicApiInvokeCollectorSourceAsync -Command $command -CollectorIds $CollectorIds -SourceIds $SourceIds -credential $Credential
            }
        }
        else
        {
            foreach ($CollectorId in $CollectorIds)
            {
                if ($null -eq $SourceIds)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $CollectorId))).uri
                    Write-Verbose -Message "Posting Get Source for all Collectors Request to $uri"
                    if ($PSVersionTable.PSVersion.Major -ge "4")
                    {
                        (Invoke-RestMethod -Uri $uri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential).sources
                    }
                    else
                    {
                        (Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential).sources
                    }
                    
                }
                else
                {
                    foreach ($SourceId in $SourceIds)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $CollectorId, $SourceId))).uri
                        Write-Verbose -Message "Posting Get Source for specific Collector, souce Request to $uri"
                        if ($PSVersionTable.PSVersion.Major -ge "4")
                        {
                            (Invoke-RestMethod -Uri $uri -Method Get -Headers $PSSumoLogicApi.contentType -Credential $Credential).source
                        }
                        else
                        {
                            (Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential).source
                        }
                        
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
