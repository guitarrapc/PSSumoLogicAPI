#Requires -Version 3.0

# # -- Collector cmdlets -- # #

function Remove-PSSumoLogicApiCollectors
{

    [CmdletBinding()]
    param
    (
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
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collctorId -f $CollectorId))).uri
                Write-Verbose -Message "Sending Get source Request to $uri"
                $result = Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Delete -Headers $PSSumoLogicApi.contentType -Credential $Credential
                $result
            }
                                
            Write-Verbose -Message "Posting Delete Collector Request to $uri"
            Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorIds $CollectorIds -credential $Credential
        }
        else # not Async Invokation
        {
            foreach ($CollectorId in $CollectorIds)
            {
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.collctorId-f $CollectorId))).uri
                Write-Verbose -Message "Posting Delete Collector Request to $uri"
                Invoke-RestMethod -Uri $uri -Method Delete -Headers $PSSumoLogicApi.contentType -Credential $Credential
            }
        }
    }
    catch
    {
        throw $_
    }
}