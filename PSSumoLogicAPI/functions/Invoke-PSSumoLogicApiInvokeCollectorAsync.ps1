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
            mandatory = 0)]
        [string]
        $JsonBody = "",

        [parameter(
            position = 3,
            mandatory = 1)]
        [System.Management.Automation.PSCredential]
        $Credential = (Get-PSSumoLogicApiCredential),

        [parameter(
            position = 4,
            mandatory = 0)]
        [string]
        $name = ""
    )

    $ErrorActionPreference = $PSSumoLogicAPI.errorPreference 

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
            if ($JsonBody -ne "")
            {
                Write-Verbose "Post json body"
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($Collector).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($JsonBody).
                    AddArgument($verbose)
            }
            else
            {
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($Collector).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($credential).
                    AddArgument($verbose).
                    AddArgument($name)
            }

            # execute ScriptBlock
            $powershell.RunspacePool = $runspacePool
            
            [array]$private:RunspaceCollection += New-Object -TypeName PSObject -Property @{
                Runspace = $powershell.BeginInvoke();
                powershell = $powershell
            }

            $count++
            Write-Verbose $count
            if ($count % 10 -eq 0)
            {
                $sleep = 60
                "Sleep for {0} sec to avoid API limnits." -f $sleep
                sleep -Seconds $sleep
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
