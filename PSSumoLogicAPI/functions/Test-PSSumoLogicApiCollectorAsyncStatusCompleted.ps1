#Requires -Version 3.0

# # -- Async cmdlets -- # #

function Test-PSSumoLogicApiCollectorAsyncStatusCompleted
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 1)]
        $PowerShellAsyncResult
    )

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference

    # check process result
    Write-Debug "check asynchronos execution has done"
    while (($PowerShellAsyncResult | sort IsCompleted -Unique).IsCompleted -ne $true)
    {
        sleep -Milliseconds 2
    }

    return ($PowerShellAsyncResult | sort IsCompleted -Unique).IsCompleted
}
