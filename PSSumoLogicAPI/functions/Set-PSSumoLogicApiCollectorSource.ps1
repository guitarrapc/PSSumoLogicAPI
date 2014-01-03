#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Set-PSSumoLogicApiCollectorSource
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
            mandatory = 1)]
        [string]
        $pathExpression,

        [parameter(
            position = 2,
            mandatory = 1)]
        [string]
        $name,

        [parameter(
            position = 3,
            mandatory = 1)]
        [validateset("LocalFile", "RemoteFile", "LocalWindowsEventLog", "RemoteWindowsEventLog", "Syslog", "Script", "Alert", "AmazonS3", "HTTP")]
        [string]
        $sourceType,

        [parameter(
            position = 4,
            mandatory = 1)]
        [string]
        $category,

        [parameter(
            position = 5,
            mandatory = 1)]
        [string]
        $description,

        [parameter(
            position = 6,
            mandatory = 0)]
        [bool]
        $alive = $PSSumoLogicApi.sourceParameter.alive,

        [parameter(
            position = 7,
            mandatory = 0)]
        [string]
        $states = $PSSumoLogicApi.sourceParameter.states,

        [parameter(
            position = 8,
            mandatory = 0)]
        [bool]
        $automaticDateParsing = $PSSumoLogicApi.sourceParameter.automaticDateParsing,

        [parameter(
            position = 9,
            mandatory = 0)]
        [string]
        $timeZone = $PSSumoLogicApi.sourceParameter.timeZone,

        [parameter(
            position = 10,
            mandatory = 0)]
        [bool]
        $multilineProcessingEnabled = $PSSumoLogicApi.sourceParameter.multilineProcessingEnabled,

        [parameter(
            position = 11,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential),

        [parameter(
            position = 12,
            mandatory = 0)]
        [switch]
        $Async
    )

    try
    {
        $json = @{ 
            source = @{ 
                pathExpression = $pathExpression
                name = $name
                sourceType = $sourceType
                category = $category
                description = $description
                alive = $alive
                states = $states
                automaticDateParsing = $automaticDateParsing
                timeZone = $timeZone
                multilineProcessingEnabled = $multilineProcessingEnabled
            }
        } | ConvertTo-Json

        if ($PSBoundParameters.Async.IsPresent)
        {
            Write-Verbose "Running Async execution"
            $command = {
                param
                (
                    [int]$CollectorId,
                    [hashtable]$PSSumoLogicApi,
                    [System.Management.Automation.PSCredential]$Credential,
                    [string]$json,
                    [string]$verbose
                )

                $VerbosePreference = $verbose
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source-f $CollectorId))).uri
                Write-Verbose -Message "Sending Get source Request to $uri"
                $result = Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Post -Credential $Credential -Body $json
                $result
            }
                                
            Invoke-SumoLogicApiInvokeCollectorAsync -Command $command -CollectorIds $CollectorIds -credential $Credential -Body $json
        }
        else # not Async Invokation
        {
            foreach ($CollectorId in $CollectorIds)
            {
                [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $CollectorId))).uri
                Write-Verbose -Message "Posting Get Source for all Collectors Request to $uri"
                $sources = Invoke-RestMethod -Uri $uri  -Method Post -Headers $PSSumoLogicApi.contentType -Credential $Credential -Body $json
                $Source.source
            }
        }
    }
    catch
    {
        throw $_
    }
}
