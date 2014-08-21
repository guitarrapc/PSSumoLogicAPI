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
        [Microsoft.PowerShell.Commands.WebRequestSession]
        $WebSession,

        [parameter(
            position = 4,
            mandatory = 1)]
        [int]
        $timeoutSec,

        [parameter(
            position = 5,
            mandatory = 0)]
        [string]
        $name = "",

        [parameter(
            position = 1,
            mandatory = 0)]
        [int[]]
        $SourceId,

        [parameter(
            position = 6,
            mandatory = 0)]
        [hashtable]
        $sourceExpression = $null
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
            if ($PSBoundParameters.ContainsKey("Verbose"))
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
                    AddArgument($webSession).
                    AddArgument($timeoutSec).
                    AddArgument($JsonBody).
                    AddArgument($verbose).
                    AddArgument($name)
            }
            elseif (($sourceExpression | measure).Count -ne 0)
            {
                foreach ($source in $SourceId)
                {
                    Write-Verbose "Put json body"
                    $private:powershell = [PowerShell]::Create().
                        AddScript($command).
                        AddArgument($Collector).
                        AddArgument($Source).
                        AddArgument($PSSumoLogicApi).
                        AddArgument($webSession).
                        AddArgument($timeoutSec).
                        AddArgument($sourceExpression).
                        AddArgument($verbose)
                }
            }
            else
            {
                $private:powershell = [PowerShell]::Create().
                    AddScript($command).
                    AddArgument($Collector).
                    AddArgument($PSSumoLogicApi).
                    AddArgument($webSession).
                    AddArgument($timeoutSec).
                    AddArgument($verbose).
                    AddArgument($name)
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
