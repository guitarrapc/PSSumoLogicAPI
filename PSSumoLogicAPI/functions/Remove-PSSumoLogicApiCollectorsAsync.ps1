#Requires -Version 3.0

# # -- Source cmdlets -- # #

function Remove-PSSumoLogicApiCollectorsAsync
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
            position = 2,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-SumoLogicApiCredential)
    )

    $ErrorActionPreference = "stop"

    try
    {
        foreach ($CollectorId in $CollectorIds)
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
        
        # check process result
        if(Test-SumoLogicCollectorAsyncStatus -PowerShellAsyncResult $runspaceCollection.RunSpace)
        {
        
            # get process result and end powershell session
            Write-Debug "obtain process result"
            foreach ($runspace in $runspaceCollection)
            {
                # obtain Asynchronos command result
                $private:task = $runspace.powershell.EndInvoke($runspace.Runspace)
            
                $property = ($task | Get-Member -MemberType NoteProperty).Name
            
                # show result
                $task.$property
            
                # Dispose pipeline
                $runspace.powershell.Dispose()
            }
        }
    }
    finally
    {
        # Dispose Runspace
        $runspacePool.Dispose()
    }
}
