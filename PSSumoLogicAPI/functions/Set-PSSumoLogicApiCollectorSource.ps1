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
        $Credential = (Get-PSSumoLogicApiCredential),

        [parameter(
            position = 12,
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
                        [System.Management.Automation.PSCredential]$Credential,
                        [string]$JsonBody,
                        [string]$verbose,
                        [string]$name
                    )

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                    $checks = (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5).sources
                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, ($checks.Name -join ", "))
                    }
                    else
                    {
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, $check.Name)
                        Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Post -ContentType $PSSumoLogicApi.contentType -Credential $Credential -Body $JsonBody -TimeoutSec 5
                    }
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync -Command $command -CollectorId $Id -credential $Credential -JsonBody $jsonBody -Name $name
            }
            else
            {
                foreach ($Collector in $Id)
                {
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.source -f $Collector))).uri
                    $checks = (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Get -ContentType $PSSumoLogicApi.contentType -Credential $Credential -TimeoutSec 5).sources
                    if ($name -in $checks.Name)
                    {
                        Write-Warning ("source name '{0}' already exist in '{1}'. Skip to next." -f $name, ($checks.Name -join ", "))
                    }
                    else
                    {
                        Write-Verbose ("source name '{0}' not found from check result '{1}'." -f $name, $($checks.Name))
                        (Invoke-RestMethod -Uri $uri.AbsoluteUri -Method Post -ContentType $PSSumoLogicApi.contentType -Credential $Credential -Body $JsonBody -TimeoutSec 5).source 
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
