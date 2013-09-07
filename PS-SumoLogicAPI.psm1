#Requires -Version 3.0

#-- sumologic api cmdlet --#

# # -- Credential cmdlets -- # #

function New-SumoLogicCredential{

    [CmdletBinding()]
    param(
        [string]
        [Parameter(
            Position = 0,
            Mandatory = 0)]
        [string]
        $save = "$PSScriptRoot",

        [Parameter(
            Position = 1,
            Mandatory = 0)]
        [string]
        $User
    )


    $cred = Get-Credential -UserName $User -Message "Input $User Password to be save."


    if ($User -eq "")
    {
        $User = $cred.UserName
    }
        
    if ((Test-Path $save) -and (-not([string]::IsNullOrEmpty($cred.Password))))
    {

        # Set CredPath with current Username
        $CredPath = Join-Path $save "$User.pass"

        # get SecureString
        try
        {
            $savePass = $cred.Password | ConvertFrom-SecureString
        }
        catch
        {
            throw 'Credential input was empty!! "None pass" is not allowed.'
        }

        
        
        if (Test-Path $CredPath)
        {
            Write-Verbose -Message "Remove existing Credential Password for $User found in $CredPath"
            Remove-Item -Path $CredPath -Force -Confirm
        }


        Write-Verbose "Save Credential Password for $User set in $CredPath"
        $savePass | Set-Content -Path $CredPath -Force


        Write-Verbose -Message "Completed: Credential Password for $User had been sat in $CredPath"
    }
    else
    {
        Write-Host "PSScriptRoot : $PSScriptRoot"
        Write-Host "'$cred.Password' : $(-not([string]::IsNullOrEmpty($cred.Password)))"
    }

}


function Get-SumoLogicCredential{

    [CmdletBinding()]
    param(
        [string]
        [Parameter(
            Position = 0,
            Mandatory = 0)]
        [string]
        $save = "$PSScriptRoot",

        [Parameter(
            Position = 1,
            Mandatory = 1)]
        [string]
        $User,

        [switch]
        $force
    )


    # Set CredPath with current Username
    $credPath = Join-Path $save "$User.pass"

    if (Test-Path $credPath)
    {
        $credPassword = Get-Content -Path $CredPath | ConvertTo-SecureString

        if ($credPassword -ne $null)
        {
            Write-Verbose "Obtain credential for User [ $User ] from $CredPath "
            $cred = New-Object System.Management.Automation.PSCredential ($user, $Credpassword)
        }
        elseif ($force)
        {
            Write-Verbose "force overrive current credential for User [ $User ] from $CredPath"
            $cred = New-Object System.Management.Automation.PSCredential ($user, $Credpassword)
        }
        else
        {
            Write-Host "Credential already created, skip Get-SumoLogicCredential" -ForegroundColor Cyan
        }
    }
    else
    {
        throw "Credential not created yet. Please run New-SumoLogicCredential to obtain credential."
    }


    return $cred

}



# # -- Collector cmdlets -- # #

function Get-SumoLogicCollectors{

    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [int[]]
        $CollectorIds = $null,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $CollectorUri = "collectors",

        [parameter(
            position = 2,
            mandatory = 0)]
        [string]
        $RootUri = "https://api.sumologic.com/api/v1",

        [parameter(
            position = 3,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try
    {
        if ($CollectorIds -eq $null)
        {
            $uri = $RootUri + "/" + $CollectorUri

            $Collectors = Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential -ErrorAction Stop
            $Collectors.collectors
        }
        else
        {
            foreach ($CollectorId in $CollectorIds)
            {
                $uri = $RootUri + "/" + $CollectorUri + "/" + $CollectorId
                Write-Warning -Message "Sending Get Collector Request to $uri"
                $Collectors = Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential -ErrorAction Stop
                $Collectors.Collector
            }
        }
        
    }
    catch
    {
        throw $_
    }
}


function Remove-SumoLogicCollectors{

    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [int[]]
        $CollectorIds,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $CollectorUri = "collectors",

        [parameter(
            position = 2,
            mandatory = 0)]
        [string]
        $RootUri = "https://api.sumologic.com/api/v1",

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $uri = $RootUri + $CollectorUri,

        [parameter(
            position = 4,
            mandatory = 0)]
        [switch]
        $parallel,

        [parameter(
            position = 5,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try
    {
        if ($CollectorIds -eq $null)
        {
            Write-Warning "CollectorIDs was null. Please input."
        }
        else
        {
            if ($parallel)
            {
                Write-Verbose "Running Parallel execution"
                Remove-SumoLogicCollectorsParallel -RootUri $RootUri -CollectorUri $CollectorUri -CollectorIds $CollectorIds -credential $Credential
            }
            else
            {
                foreach ($CollectorId in $CollectorIds)
                {
                    $uri = $RootUri + "/" + $CollectorUri + "/" + $CollectorId
                    Write-Warning -Message "Posting Delete Collector Request to $uri"
                    Invoke-RestMethod -Uri $uri -Method Delete -Credential $Credential -ErrorAction Stop
                }
            }
        }
    }
    catch
    {
        throw $_
    }
}


#-- workflow for parallel execution --#

workflow Remove-SumoLogicCollectorsParallel{

    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = 1,
            Position = 0)]
        [string]
        $RootUri,

        [parameter(
            Mandatory = 1,
            Position = 1)]
        [string]
        $CollectorUri,

        [parameter(
            Mandatory = 1,
            Position = 2)]
        [int[]]
        $CollectorIds,
        
        [parameter(
            Mandatory = 1,
            Position = 3)]
        [System.Management.Automation.PSCredential]
        $credential
    )

    foreach -Parallel ($collectorId in $CollectorIds)
    {
        inlinescript
        {
            $uri = $using:RootUri + "/" + $using:CollectorUri + "/" + $using:CollectorId
            Write-Warning -Message "Posting Delete Collector Request to $uri"
            Invoke-RestMethod -Uri $uri -Method Delete -Credential $using:Credential -ErrorAction Stop
        }
    }
}


# # -- Source cmdlets -- # #

function Get-SumoLogicCollectorsSource{

    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [int[]]
        $SourceIds = $null,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $sourceUri = "sources",

        [parameter(
            position = 2,
            mandatory = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int[]]
        $CollectorIds = $null,

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $CollectorUri = "collectors",

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $RootUri = "https://api.sumologic.com/api/v1",

        [parameter(
            position = 5,
            mandatory = 0)]
        [switch]
        $parallel,

        [parameter(
            position = 6,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try
    {
        if ($CollectorIds -ne $null)
        {
            if ($parallel)
            {
                Write-Verbose "Running Parallel execution"
                Get-SumoLogicCollectorsSourceParallel -RootUri $RootUri -CollectorUri $CollectorUri -CollectorIds $CollectorIds -SourceIds $SourceIds -sourceUri $sourceUri -credential $Credential
            }
            else
            {
                foreach ($CollectorId in $CollectorIds)
                {
                    if ($null -eq $SourceIds)
                    {
                        $uri = $RootUri + "/" + $CollectorUri + "/" + $CollectorId + "/" + $SourceUri
                        Write-Warning -Message "Sending Get source Request to $uri"
                        $Sources = Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential -ErrorAction Stop
                        $Sources.sources
                    }
                    else
                    {
                        foreach ($SourceId in $SourceIds)
                        {
                            $uri = $RootUri + "/" + $CollectorUri + "/" + $CollectorId + "/" + $SourceUri + "/" + $SourceId
                            Write-Warning -Message "Sending Get source Request to $uri"
                            $Source = Invoke-RestMethod -Uri $uri -Method Get -Credential $Credential -ErrorAction Stop
                            $Source.source
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


function Set-SumoLogicCollectorsSource{

    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            mandatory = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int[]]
        $CollectorIds = $null,

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
        [validateset("LocalFile","RemoteFile","LocalWindowsEventLog","RemoteWindowsEventLog","Syslog","Script","Alert","AmazonS3","HTTP")]
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
        $alive = $true,

        [parameter(
            position = 7,
            mandatory = 0)]
        [string]
        $states = "",

        [parameter(
            position = 8,
            mandatory = 0)]
        [bool]
        $automaticDateParsing = $true,

        [parameter(
            position = 9,
            mandatory = 0)]
        [string]
        $timeZone = "Asia/Tokyo",

        [parameter(
            position = 10,
            mandatory = 0)]
        [bool]
        $multilineProcessingEnabled = $true,

        [parameter(
            position = 11,
            mandatory = 0)]
        [switch]
        $parallel,

        [parameter(
            position = 12,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential
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

        if ($parallel)
        {
            Write-Verbose -Message "Running Parallel execution"
            Set-SumoLogicCollectorsSourceParallel -CollectorIds $CollectorIds -credential $Credential -json $json
        }
        else
        {
            foreach ($CollectorId in $CollectorIds)
            {
                $uri = "https://api.sumologic.com/api/v1/collectors/$CollectorId/sources/"
                Write-Warning -Message "Sending set source POST Request to $uri"
                $source = Invoke-RestMethod -Method Post -Uri $uri -Credential $credential -ContentType "application/json" -Body $json -ErrorAction Stop
                $source.source
            }
        }
    }
    catch
    {
        throw $_
    }
}



function Remove-SumoLogicCollectorsSource{

    [CmdletBinding(
    )]
    param(
        [parameter(
            position = 0,
            mandatory = 0,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [int[]]
        $SourceIds = $null,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $sourceUri = "sources",

        [parameter(
            position = 2,
            mandatory = 1,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true)]
        [int]
        $CollectorId = $null,

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $CollectorUri = "collectors",

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $RootUri = "https://api.sumologic.com/api/v1",

        [parameter(
            position = 5,
            mandatory = 0)]
        [switch]
        $parallel,

        [parameter(
            position = 6,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential
    )

    try
    {
        if ($CollectorId -eq $null)
        {
            Write-Error "CollectorIDs was null. Please input."
        }

        if (($CollectorId -eq $null) -and ($SourceIds -ne $null))
        {
            Write-Error "CollectorIds[$CollectorId] or SourceIds[$SourceIds] contains null. Please input value."
        }
        else
        {
            if ($parallel)
            {
                Write-Verbose "Running Parallel execution"
                Remove-SumoLogicCollectorsSourceParallel -RootUri $RootUri -CollectorUri $CollectorUri -CollectorId $CollectorId -SourceIds $SourceIds -sourceUri $sourceUri -credential $Credential
            }
            else
            {
                foreach ($SourceId in $SourceIds)
                {
                    $uri = $RootUri + "/" + $CollectorUri + "/" + $CollectorId + "/" + $SourceUri + "/" + $SourceId
                    Write-Warning -Message "Sending Delete source Request to $uri"
                    $Source = Invoke-RestMethod -Method Delete -Uri $uri -Credential $Credential -ErrorAction Stop
                    $Source.source
                }
            }
        }
    }
    catch
    {
        throw $_
    }
}

#-- workflow for parallel execution --#

workflow Get-SumoLogicCollectorsSourceParallel{

    [CmdletBinding()]
    param(
        [parameter(
            position = 0,
            mandatory = 0)]
        [int[]]
        $SourceIds,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $SourceUri,

        [parameter(
            position = 2,
            mandatory = 1)]
        [int[]]
        $CollectorIds,

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $CollectorUri,

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $RootUri,
        
        [parameter(
            Mandatory = 1,
            Position = 4)]
        [System.Management.Automation.PSCredential]
        $credential
    )

    foreach -Parallel ($collectorId in $CollectorIds)
    {
        inlinescript{
            if ($null -eq $using:SourceIds)
            {
                $sourceuri = $using:RootUri + "/" + $using:CollectorUri + "/" + $using:CollectorId + "/" + $using:SourceUri
                $sources = Invoke-RestMethod -Method Get -Uri $sourceuri -Credential $using:Credential -ErrorAction Stop
                Write-Warning -Message "Show Get source Request to $sourceuri"
                $sources.sources
            }
            else
            {
                foreach ($SourceId in $using:SourceIds)
                {
                    $sourceiduri = $using:RootUri + "/" + $using:CollectorUri + "/" + $using:CollectorId + "/" + $using:SourceUri + "/" + $using:SourceId
                    $source = Invoke-RestMethod -Method Get -Uri $sourceiduri -Credential $using:Credential -ErrorAction Stop
                    Write-Warning -Message "Show Get source Result to $sourceuri"
                    $source.source
                }
            }
        }
    }
}



workflow Set-SumoLogicCollectorsSourceParallel{

    [CmdletBinding()]
    param(
        [parameter(
            Mandatory = 1,
            Position = 0)]
        [int[]]
        $CollectorIds,
        
        [parameter(
            Mandatory = 1,
            Position = 1)]
        [System.Management.Automation.PSCredential]
        $credential,

        [parameter(
            Mandatory = 1,
            Position = 2)]
        [string]
        $json

    )

    foreach -Parallel ($collectorId in $CollectorIds)
    {
        inlinescript
        {
            $uri = "https://api.sumologic.com/api/v1/collectors/$using:CollectorId/sources/"
            Write-Warning -Message "Sending set source POST Result to $uri"
            $source = Invoke-RestMethod -Method Post -Uri $uri -Credential $using:Credential -ContentType "application/json" -Body $using:json -ErrorAction Stop
            $source.source
        }
    }
}


workflow Remove-SumoLogicCollectorsSourceParallel{

    [CmdletBinding()]
    param(
        [parameter(
            position = 0,
            mandatory = 0)]
        [int[]]
        $SourceIds,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $SourceUri,

        [parameter(
            position = 2,
            mandatory = 1)]
        [int]
        $CollectorId,

        [parameter(
            position = 3,
            mandatory = 0)]
        [string]
        $CollectorUri,

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $RootUri,
        
        [parameter(
            Mandatory = 1,
            Position = 2)]
        [System.Management.Automation.PSCredential]
        $credential
    )

    foreach -Parallel ($sourceid in $SourceIds)
    {
        inlinescript
        {
            $sourceiduri = $using:RootUri + "/" + $using:CollectorUri + "/" + $using:CollectorId + "/" + $using:SourceUri + "/" + $using:SourceId
            $source = Invoke-RestMethod -Method Delete -Uri $sourceiduri -Credential $using:Credential -ErrorAction Stop
            Write-Warning -Message "Send Delete source Request to $sourceiduri"
            $source.source
        }
    }
}


#-- Export Modules when loading this module --#

Export-ModuleMember `
    -Function Get-SumoLogicCollectors,
        Get-SumoLogicCollectorsSource,
        Get-SumoLogicCredential,
        New-SumoLogicCredential,
        Remove-SumoLogicCollectors,
        Remove-SumoLogicCollectorsSource,
        Set-SumoLogicCollectorsSource `
    -Variable * `
    -Alias * 