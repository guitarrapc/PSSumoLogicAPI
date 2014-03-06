#Requires -Version 3.0

# # -- Credential cmdlets -- # #

function New-PSSumoLogicApiCredential
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

    $cred = Get-Credential -UserName $User -Message ("Input {0}'s Password to be save in '{1}'." -f $User, $path)
    
    try
    {
        # Set CredPath with current Username
        $CredPath = Join-Path $path $User

        if (-not (Test-Path $CredPath))
        {
            Write-Verbose ("trying to create credential file in '{0}'" -f $CredPath)
            New-Item -Path $CredPath -ItemType File -Force
        }
        else
        {
            Write-Verbose -Message ("Removing old Credential Password for '{0}' had been sat in '{1}'" -f $cred.UserName, $CredPath)
            Remove-Item -Path $CredPath -Force -Confirm
        }

        # get SecureString
        $pass = $cred.Password | ConvertFrom-SecureString

        Write-Verbose ("Saving old Credential Password for '{0}' in '{1}'" -f $cred.UserName, $CredPath)
        $pass | Set-Content -Path $CredPath -Force

        Write-Verbose -Message "Operation successfully completed."
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
