#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Invoke-PSSumoLogicApiInvokeCollectorAsync
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
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential)
    )

    $ErrorActionPreference = "stop"

    try
    {
        # create run space and open
        $runSpacePool = New-PSSumoLogicApiRunSpacePool
        $runSpacePool.Open()

        foreach ($Collector in $CollectorId)
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
            if ($json -ne "")
            {
                Write-Verbose "Post json body"
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($Collector).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($json).
                    AddArgument($verbose)
            }
            else
            {
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($Collector).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($verbose)
            }

            # execute ScriptBlock
            $powershell.RunspacePool = $runspacePool
            
            [array]$private:RunspaceCollection += New-Object -TypeName PSObject -Property @{
                Runspace = $powershell.BeginInvoke();
                powershell = $powershell
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
