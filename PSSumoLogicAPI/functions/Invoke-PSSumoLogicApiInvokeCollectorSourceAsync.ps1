#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Invoke-PSSumoLogicApiInvokeCollectorSourceAsync
{

    [CmdletBinding()]
    param
    (
        [parameter(
            position = 0,
            mandatory = 1)]
        [ScriptBlock]
        $Command,
        
        [parameter(
            position = 1,
            mandatory = 1)]
        [int[]]
        $CollectorIds,

        [parameter(
            position = 1,
            mandatory = 1)]
        [int[]]
        $SourceIds,

        [parameter(
            position = 1,
            mandatory = 0)]
        [string]
        $json = "",

        [parameter(
            position = 3,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential)
    )

    $ErrorActionPreference = "stop"

    try
    {
        foreach ($CollectorId in $CollectorIds)
        {
            foreach ($SourceId in $SourceIds)
            {
                # Verbose settings for Async Command inside
                if ($PSBoundParameters.Verbose.IsPresent)
                {
                    $private:verbose = "continue"
                }
                else
                {
                    $private:verbose = $VerbosePreference
                }

                # Main Invokation
                # create sctiptblock Static
                Write-Debug "start asynchronous invokation"
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($CollectorId).
                    AddArgument($SourceId).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($verbose)

                # execute ScriptBlock
                $runSpacePool = New-PSSumoLogicApiRunSpacePool
                $runSpacePool.Open()
                $powershell.RunspacePool = $runspacePool
            
                [array]$private:RunspaceCollection += New-Object -TypeName PSObject -Property @{
                    Runspace = $powershell.BeginInvoke();
                    powershell = $powershell
                }
            }
        }
        
        # check process result
        if(Test-PSSumoLogicApiCollectorAsyncStatusCompleted -PowerShellAsyncResult $runspaceCollection.RunSpace)
        {
            Get-PSSumoLogicApiCollectorAsyncResult -RunspaceCollection $runspaceCollection
        }
    }
    finally
    {
        # Dispose Runspace
        $runspacePool.Dispose()
    }
}
