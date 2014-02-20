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
        $CollectorId,

        [parameter(
            position = 2,
            mandatory = 1)]
        [int[]]
        $SourceId,

        [parameter(
            position = 3,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-PSSumoLogicApiCredential)
    )

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference

    try
    {
        # create run space and open
        $runSpacePool = New-PSSumoLogicApiRunSpacePool
        $runSpacePool.Open()

        foreach ($Collector in $CollectorId)
        {
            foreach ($Source in $SourceId)
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
                    AddArgument($Collector).
                    AddArgument($Source).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($verbose)

                # execute ScriptBlock
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
