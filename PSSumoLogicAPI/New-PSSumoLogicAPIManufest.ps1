$script:module = "PSSumoLogicAPI"
$script:moduleVersion = "1.0.0"
$script:description = "PowerShell SumoLogic API Caller";
$script:copyright = "06/Dec/2013 -"
$script:RequiredModules = @()
$script:clrVersion = "4.0.0.0" # .NET 4.0 with StandAlone Installer "4.0.30319.1008" or "4.0.30319.1" , "4.0.30319.17929" (Win8/2012)

$script:functionToExport = @(
    "Get-PSSumoLogicApiCollectorAsyncResult",
    "Get-PSSumoLogicApiCollector",
    "Get-PSSumoLogicApiCollectorSource",
    "Get-PSSumoLogicApiCredential",
    "Invoke-PSSumoLogicApiInvokeCollectorAsync",
    "Invoke-PSSumoLogicApiInvokeCollectorSourceAsync",
    "New-PSSumoLogicApiCredential",
    "New-PSSumoLogicApiRunSpacePool",
    "Remove-PSSumoLogicApiCollector",
    "Remove-PSSumoLogicApiCollectorSource",
    "Set-PSSumoLogicApiCollectorSource",
    "Test-PSSumoLogicApiCollectorAsyncStatusCompleted"
)

$script:variableToExport = "PSSumoLogicAPI"

$script:moduleManufest = @{
    Path = "$module.psd1";
    Author = "guitarrapc";
    CompanyName = "guitarrapc"
    Copyright = ""; 
    ModuleVersion = $moduleVersion
    Description = $description
    PowerShellVersion = "3.0";
    DotNetFrameworkVersion = "4.0";
    ClrVersion = $clrVersion;
    RequiredModules = $RequiredModules;
    NestedModules = "$module.psm1";
    CmdletsToExport = "*";
    FunctionsToExport = $functionToExport
    VariablesToExport = $variableToExport;
    AliasesToExport = "*";
}

New-ModuleManifest @moduleManufest