#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Get-PSSumoLogicApiCollectorSource
{
    [CmdletBinding(
    )]
    param(
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorId,

        # Input Source Id
        [parameter(
            position = 1,
            mandatory = 0)]
        [int[]]
        $Id = $null,

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
                if ($null -eq $SourceId)
                {
                    $command = {
                        param
                        (
                            [int]$Collector,
                            [hashtable]$PSSumoLogicApi,
                            [System.Management.Automation.PSCredential]$Credential,
                            [string]$verbose
                        )

                        $VerbosePreference = $verbose
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
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
                                
                    Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $CollectorId -credential $Credential
                }
                else
                {
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

                    Invoke-PSSumoLogicApiInvokeCollectorSourceAsync -Command $command -CollectorId $CollectorId -SourceId $Id -credential $Credential
                }
            }
            else
            {
                foreach ($Collector in $CollectorId)
                {
                    if ($null -eq $Id)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
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
                        foreach ($Source in $Id)
                        {
                            [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
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
}
