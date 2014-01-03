#Requires -Version 3.0

Write-Verbose "Loading PSSumoLogicAPI.psm1"

# PSSumoLogicAPI
#
# Copyright (c) 2013 guitarrapc
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.


#-- Public Loading Module Custom Configuration Functions --#

function Import-PSSumoLogicAPIConfiguration
{

    [CmdletBinding()]
    param
    (
        [string]
        $configdir = $PSSumoLogicAPI.modulePath
    )

    $ErrorActionPreference = "Stop"

    $PSSumoLogicAPIConfigFilePath = (Join-Path $configdir $PSSumoLogicAPI.defaultconfigurationfile)

    if (Test-Path $PSSumoLogicAPIConfigFilePath -pathType Leaf) 
    {
        try 
        {
            . $PSSumoLogicAPIConfigFilePath
        } 
        catch 
        {
            throw ("Error Loading Configuration from {0}: " -f $PSSumoLogicAPI.defaultconfigurationfile) + $_
        }
    }
}



#-- Private Loading Module Parameters --#

# contains default base configuration, may not be override without version update.
$Script:PSSumoLogicAPI                        = @{}
$PSSumoLogicAPI.name                          = "PSSumoLogicAPI"                                         # contains the Name of Module
$PSSumoLogicAPI.modulePath                    = Split-Path -parent $MyInvocation.MyCommand.Definition
$PSSumoLogicAPI.helpersPath                   = "\functions\*.ps1"                                       # path of functions
$PSSumoLogicAPI.credentialPath                = "\save"                                                  # path of credential
$PSSumoLogicAPI.defaultconfigurationfile      = "\config\PSSumoLogicAPI-config.ps1"                      # default configuration file name within PSSumoLogicAPI.psm1
$PSSumoLogicAPI.context                       = New-Object System.Collections.Stack                      # holds onto the current state of all variables

$PSSumoLogicAPI.originalErrorActionPreference = $ErrorActionPreference
$PSSumoLogicAPI.errorPreference               = "Stop"
$PSSumoLogicAPI.originalDebugPreference       = $DebugPreference
$PSSumoLogicAPI.debugPreference               = "SilentlyContinue"

#-- Fixed parameters for SumoLogic Service --#

# content type
$PSSumoLogicAPI.contentType        = @{Accept="application/json"}

# uri
$PSSumoLogicAPI.uri = @{
    scheme                         = [string]"https"
    collector                      = [uri]"api.sumologic.com/api/v1/collectors"
    collectorId                    = [uri]"api.sumologic.com/api/v1/collectors/{0}"
    source                         = [uri]"api.sumologic.com/api/v1/collectors/{0}/sources"
    sourceId                       = [uri]"api.sumologic.com/api/v1/collectors/{0}/sources/{1}"
}

$PSSumoLogicAPI.sourceParameter    = @{
    alive                          = [bool]$true
    states                         = [string]""
    automaticDateParsing           = [bool]$true
    timeZone                       = [string]"Asia/Tokyo"
    multilineProcessingEnabled     = [bool]$true
}

#-- Public Loading Module Parameters (Recommend to use ($PSSumoLogicAPI.defaultconfigurationfile) for customization) --#

# credential
$PSSumoLogicAPI.credential = @{
    user                           = "INPUT YOUR Email Address to logon"
}

# RunSpace Pool size
$PSSumoLogicAPI.runSpacePool = @{
    minPoolSize                    = 50
    maxPoolSize                    = 50
}

# -- Export Modules when loading this module -- #
Resolve-Path (Join-Path $PSSumoLogicAPI.modulePath $PSSumoLogicAPI.helpersPath) | 
    where { -not ($_.ProviderPath.Contains(".Tests.")) } |
    % { . $_.ProviderPath }

# -- Import Default configuration file -- #
Import-PSSumoLogicAPIConfiguration

#-- Export Modules when loading this module --#

Export-ModuleMember `
    -Cmdlet * `
    -Function * `
    -Variable * `
    -Alias *