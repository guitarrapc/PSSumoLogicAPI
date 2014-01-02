#Requires -Version 3.0

# # -- Credential cmdlets -- # #

function Get-PSSumoLogicApiCredential
{
    [CmdletBinding()]
    param
    (
        [string]
        [Parameter(
            Position = 0,
            Mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $path = (Join-Path $PSSumoLogicAPI.modulePath $PSSumoLogicAPI.credentialPath),

        [Parameter(
            Position = 1,
            Mandatory = 0)]
        [ValidateNotNullOrEmpty()]
        [string]
        $User = $PSSumoLogicAPI.credential.user
    )

    $ErrorActionPreference = $PSSumoLogicApi.errorPreference

    # Set CredPath with current Username
    $credPath = Join-Path $path $User -Resolve

    try
    {
        $credPassword = Get-Content -Path $CredPath | ConvertTo-SecureString

        Write-Verbose "force overrive current credential for User [ $User ] from $CredPath"
        $cred = New-Object System.Management.Automation.PSCredential ($user, $Credpassword)

        return $cred
    }
    catch [System.Management.Automation.ActionPreferenceStopException]
    {
        switch ($_.Exception)
        {
            [System.Management.Automation.ItemNotFoundException]     {throw $_.Exception}
            [System.Management.Automation.ParameterBindingException] {throw $_.Exception}
            default                                                  {throw $_}
        }
    }
}