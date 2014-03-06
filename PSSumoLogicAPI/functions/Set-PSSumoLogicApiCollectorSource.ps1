#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Set-PSSumoLogicApiCollectorSource
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
        [SumoLogicSourceType]
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
        [ValidateNotNullOrEmpty()]
        [bool]
        $alive = $PSSumoLogicApi.sourceParameter.alive,

        [parameter(
            position = 7,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $states = $PSSumoLogicApi.sourceParameter.states,

        [parameter(
            position = 8,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $automaticDateParsing = $PSSumoLogicApi.sourceParameter.automaticDateParsing,

        [parameter(
            position = 9,
            mandatory = 0)]
        [validateScript({Check-PSSumoLogicTimeZone -TimeZone $_ })]
        [string]
        $timeZone = $PSSumoLogicApi.sourceParameter.timeZone,

        [parameter(
            position = 10,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [bool]
        $multilineProcessingEnabled = $PSSumoLogicApi.sourceParameter.multilineProcessingEnabled,

        [parameter(
            position = 11,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 12,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

        [parameter(
            position = 13,
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
            $jsonBody = @{ 
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
                        [int]$Collector,
                        [hashtable]$PSSumoLogicApi,
                        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                        [int]$timeoutSec,
                        [string]$JsonBody,
                        [string]$verbose,
                        [string]$name
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri

                    $checkParam = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Get"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }
                    $checks = (Invoke-RestMethod @checkParam).sources

                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, ($checks.Name -join ", "))
                    }
                    else
                    {
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Post"
                            ContentType = $PSSumoLogicApi.contentType 
                            Body        = $JsonBody 
                            WebSession  = $WebSession 
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, $check.Name)
                        Invoke-RestMethod @param
                    }
                }

                $asyncParam = @{
                    Command     = $command
                    CollectorId = $Id
                    WebSession  = $WebSession
                    TimeoutSec  = $timeoutSec
                    JsonBody    = $jsonBody
                    Name        = $name
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam
            }
            else
            {
                foreach ($Collector in $Id)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                    $checkParam = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Get"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }
                    $checks = (Invoke-RestMethod @checkParam).sources

                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, ($checks.Name -join ", "))
                    }
                    else
                    {
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Post"
                            ContentType = $PSSumoLogicApi.contentType 
                            Body        = $JsonBody 
                            WebSession  = $WebSession 
                            TimeoutSec  = $timeoutSec
                        }
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, $($checks.Name))
                        (Invoke-RestMethod @param).source 
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
