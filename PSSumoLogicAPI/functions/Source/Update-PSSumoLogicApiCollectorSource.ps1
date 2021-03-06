#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Update-PSSumoLogicApiCollectorSource
{

    [CmdletBinding()]
    param
    (
        # Input CollectorId
        [parameter(
            position = 0,
            mandatory = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $CollectorId,

        [parameter(
            position = 1,
            mandatory = 1,
            ValueFromPipeline,
            ValueFromPipelineByPropertyName)]
        [ValidateNotNullOrEmpty()]
        [int[]]
        $SourceId,

        [parameter(
            position = 2,
            mandatory = 0)]
        [string]
        $pathExpression,

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $name,

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $category,

        [parameter(
            position = 5,
            mandatory = 0)]
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
        [validateSet(
            "Etc/GMT-12",
            "Etc/GMT-11",
            "Pacific/Midway",
            "America/Adak",
            "America/Anchorage",
            "Pacific/Gambier",
            "America/Dawson_Creek",
            "America/Ensenada",
            "America/Los_Angeles",
            "America/Chihuahua",
            "America/Denver",
            "America/Belize",
            "America/Cancun",
            "America/Chicago",
            "Chile/EasterIsland",
            "America/Bogota",
            "America/Havana",
            "America/New_York",
            "America/Caracas",
            "America/Campo_Grande",
            "America/Glace_Bay",
            "America/Goose_Bay",
            "America/Santiago",
            "America/La_Paz",
            "America/Argentina/Buenos_Aires",
            "America/Montevideo",
            "America/Araguaina",
            "America/Godthab",
            "America/Miquelon",
            "America/Sao_Paulo",
            "America/St_Johns",
            "America/Noronha",
            "Atlantic/Cape_Verde",
            "Europe/Belfast",
            "Africa/Abidjan",
            "Europe/Dublin",
            "Europe/Lisbon",
            "Europe/London",
            "UTC",
            "Africa/Algiers",
            "Africa/Windhoek",
            "Atlantic/Azores",
            "Atlantic/Stanley",
            "Europe/Amsterdam",
            "Europe/Belgrade",
            "Europe/Brussels",
            "Africa/Cairo",
            "Africa/Blantyre",
            "Asia/Beirut",
            "Asia/Damascus",
            "Asia/Gaza",
            "Asia/Jerusalem",
            "Africa/Addis_Ababa",
            "Asia/Riyadh89",
            "Europe/Minsk",
            "Asia/Tehran",
            "Asia/Dubai",
            "Asia/Yerevan",
            "Europe/Moscow",
            "Asia/Kabul",
            "Asia/Tashkent",
            "Asia/Kolkata",
            "Asia/Katmandu",
            "Asia/Dhaka",
            "Asia/Yekaterinburg",
            "Asia/Rangoon",
            "Asia/Bangkok",
            "Asia/Novosibirsk",
            "Etc/GMT+8",
            "Asia/Hong_Kong",
            "Asia/Krasnoyarsk",
            "Australia/Perth",
            "Australia/Eucla",
            "Asia/Irkutsk",
            "Asia/Seoul",
            "Asia/Tokyo",
            "Australia/Adelaide",
            "Australia/Darwin",
            "Pacific/Marquesas",
            "Etc/GMT+10",
            "Australia/Brisbane",
            "Australia/Hobart",
            "Asia/Yakutsk",
            "Australia/Lord_Howe",
            "Asia/Vladivostok",
            "Pacific/Norfolk",
            "Etc/GMT+12",
            "Asia/Anadyr",
            "Asia/Magadan",
            "Pacific/Auckland",
            "Pacific/Chatham",
            "Pacific/Tongatapu",
            "Pacific/Kiritimati")]
        [string]
        $timeZone,

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
        [hashtable]
        $filters,

        [parameter(
            position = 12,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession = $PSSumoLogicAPI.WebSession,

        [parameter(
            position = 13,
            mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [int]
        $timeoutSec = $PSSumoLogicAPI.TimeoutSec,

        [parameter(
            position = 14,
            mandatory = 0)]
        [switch]
        $Async     
    )

    begin
    {
        $ErrorActionPreference = $PSSumoLogicApi.errorPreference

        function mergehashtables($htold, $htnew)
        {
            $keys = $htold.getenumerator() | foreach-object {$_.key}
            $keys | where {$htnew.containsKey($_)} | % { $htold.remove($_) }
            $htnew = $htold + $htnew
            return $htnew
        }
    }

    process
    {
        try
        {	
            $filtersobject = New-Object -TypeName PSCustomObject -Property $filters
            $sourceexpression = @{}
            if($pathExpression){$sourceexpression.add("pathExpression", $pathExpression)}
            if($name){$sourceexpression.add("name",$name)}
            if($sourceType){$sourceexpression.add("sourceType","$sourceType")}
            if($category){$sourceexpression.add("category",$category)}
            if($description){$sourceexpression.add("description",$description)}
            if($timeZone){$sourceexpression.add("timeZone",$timeZone)}
            if($filters){$sourceexpression.add("filters",$filtersobject)}
            if($multilineProcessingEnabled){$sourceexpression.add("multilineProcessingEnabled",$multilineProcessingEnabled)}
            
            $jsonTemp = @{ 
                source = $sourceexpression
            }

            foreach($key in @($jsonTemp.source.Keys)) { if($jsonTemp.source.$key -eq $null) { $jsonTemp.source.Remove($key) } }
            
            $jsonBody = $jsonTemp | ConvertTo-Json
            if ($PSBoundParameters.ContainsKey("Async"))
            {
                Write-Verbose "Running Async execution"
                $command = {
                    param
                    (
                        [int]$Collector,
                        [int]$Source,
                        [hashtable]$PSSumoLogicApi,
                        [Microsoft.PowerShell.Commands.WebRequestSession]$WebSession,
                        [int]$timeoutSec,
                        [hashtable]$sourceExpression,
                        [string]$verbose
                    )

                    function mergehashtables($htold, $htnew)
                    {
                        $keys = $htold.getenumerator() | foreach-object {$_.key}
                        $keys | where {$htnew.containsKey($_)} | % { $htold.remove($_) }
                        $htnew = $htold + $htnew
                        return $htnew
                    }

                    $VerbosePreference = $verbose
                    [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                    $checkParam = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Get"
                        ContentType = $PSSumoLogicApi.contentType
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                    }

                    $checks = (Invoke-webrequest @checkParam)
                    $currentParams = ($checks.content | ConvertFrom-Json).source
                    Write-Verbose "$currentParams"
                    $currenthash = @{}
                    $currentParams.psobject.properties | % { $currenthash[$_.Name] = $_.Value }
                    $mergehash = mergehashtables $currenthash $sourceexpression
                    $jsonmerge = $mergehash | convertto-json
                    $jsonmergeBody = "{`n`"source`":`n"+$jsonmerge+"`n}"
                    $ETag = $checks.Headers.ETag
                    $ETagHash = @{
                        "If-Match" = $ETag
                    }
                    $param = @{
                        Uri         = $uri.AbsoluteUri
                        Method      = "Put"
                        ContentType = $PSSumoLogicApi.contentType 
                        Body        = $jsonmergeBody 
                        WebSession  = $WebSession
                        TimeoutSec  = $timeoutSec
                        Headers     = $ETagHash
                    }
                    (Invoke-RestMethod @param).source
                }

                $asyncParam = @{
                    Command     = $command
                    CollectorId = $CollectorId
                    SourceId    = $SourceId
                    WebSession  = $WebSession
                    TimeoutSec  = $timeoutSec
                    sourceExpression = $sourceExpression
                }
                Invoke-PSSumoLogicApiInvokeCollectorAsync @asyncParam
            }
            else
            {
                foreach ($Collector in $CollectorId)
                {
                    foreach ($Source in $SourceId)
                    {
                        [uri]$uri = (New-Object System.UriBuilder ($PSSumoLogicApi.uri.scheme, ($PSSumoLogicAPI.uri.sourceId -f $Collector, $Source))).uri
                        $checkParam = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Get"
                            ContentType = $PSSumoLogicApi.contentType
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                        }
                        
                        $checks = (Invoke-webrequest @checkParam)
                        $currentParams = ($checks.content | ConvertFrom-Json).source
                        $currenthash = @{}
                        $currentParams.psobject.properties | % { $currenthash[$_.Name] = $_.Value }
                        $mergehash = mergehashtables $currenthash $sourceexpression
                        $jsonmerge = $mergehash | convertto-json
                        $jsonmergeBody = "{`n`"source`":`n"+$jsonmerge+"`n}"
                        $ETag = $checks.Headers.ETag
                        $ETagHash = @{
                            "If-Match" = $ETag
                        }
                        $param = @{
                            Uri         = $uri.AbsoluteUri
                            Method      = "Put"
                            ContentType = $PSSumoLogicApi.contentType 
                            Body        = $jsonmergeBody 
                            WebSession  = $WebSession
                            TimeoutSec  = $timeoutSec
                            Headers     = $ETagHash
                        }
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
