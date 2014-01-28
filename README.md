PSSumoLogicAPI
==========

PSSumoLogicApi will help you manage SumoLogic Collector management automation.

Unfortunately there are no management for bulk collectors on Web UI of SumoLogic. Therefore API is needed to manage hundred of collectors, sources.

This module is in use of production and ease me all time adding new server or change configuration of SumoLogic:)

Have a fun with SumoLogic! Windows Powershell will help your Windows life!

# SumoLogic Collector Management API

See here.

[SumoLogic/sumo-api-doc](https://github.com/SumoLogic/sumo-api-doc/wiki/collector-management-api)

# Cmdlets

You can check what kind of functions included in module.

```
Get-Command -Module PSSumoLogicApi
```

Here's Cmdlets use in public

```text
CommandType Name                                 ModuleName    
----------- ----                                 ----------    
Function    Get-PSSumoLogicApiCollector          PSSumoLogicAPI
Function    Get-PSSumoLogicApiCollectorSource    PSSumoLogicAPI
Function    Get-PSSumoLogicApiCredential         PSSumoLogicAPI
Function    New-PSSumoLogicApiCredential         PSSumoLogicAPI
Function    Remove-PSSumoLogicApiCollector       PSSumoLogicAPI
Function    Remove-PSSumoLogicApiCollectorSource PSSumoLogicAPI
Function    Set-PSSumoLogicApiCollectorSource    PSSumoLogicAPI
```

# Test

You can find sample source in [Test](https://github.com/guitarrapc/PSSumoLogicAPI/tree/master/PSSumoLogicAPI/Test)

## Credential

### Create Credential secure Password File

```PowerShell
New-PSSumoLogicApiCredential -user hoge@hoge.com
```

if you configure ```.\PSSumoLogicAPI\config\PSSumoLogicAPI-config.ps1``` as to input username, 

```PowerShell
$PSSumoLogicAPI.credential = @{
    user                           = "INPUT YOUR Email Address to logon"
}

#change it like

$PSSumoLogicAPI.credential = @{
    user                           = "hoge@hoge.com"
}
```
you can omit -user parameter, as default use ```$PSSumoLogicAPI.credential.user```, in this case hoge@hoge.com

```PowerShell
New-PSSumoLogicApiCredential
```


### Get Credential secure Password from file

Onece you create credential, you can get it easily.

```PowerShell
Get-PSSumoLogicApiCredential -user hoge@hoge.com
```

you can omit username if you configure ```.\PSSumoLogicAPI\config\PSSumoLogicAPI-config.ps1```

```PowerShell
Get-PSSumoLogicApiCredential
```

you can reuse Credential.

```PowerShell
$credential = Get-PSSumoLogicApiCredential
```


## Collector

### Get SumoLogic Collectors of your account

```PowerShell
Get-PSSumoLogicApiCollectors -Credential $credential
```

You can reuse collectors.

```PowerShell
$Collectors = Get-PSSumoLogicApiCollectors -Credential $credential
```

specify collector ids.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential

# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Get-PSSumoLogicApiCollector -Credential $credential -Id ($collectors.Id | select -First 5)
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async

# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Asynchronize request for each CollectorId")
Get-PSSumoLogicApiCollector -Credential $credential -Id ($collectors.Id | select -First 5) -Async
```

it will speed up about x5 then not using switch.

### Remove Collectors

Specify Collector id to remove collectors.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 5

# Remove each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Credential $credential
```

Asynchronouse execution will speed up.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | select -First 5

# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Credential $credential -Async
```

It may good to filter Collector name, OS or status to select which collector to delete.
Where-Object or .Where({}) will ease you filtering object.

## Source

### Get SumoLogic Source for Collectors of your account

Get all collectors source.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $collectors.id
```

Get First 4 Collectors source.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 4

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $collectors.id
```

Asynchronouse execution will speed up.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $collectors.id -Async
```
You can specify Source Ids if you know.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId 111111 -Id 123 -Async
```

### Set SumoLogic Source for Collectors of your account

You can set for each Source Type, will show in intellisence.

```PowerShell
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | Select -First 2

# Set Sources
$host.Ui.WriteVerboseLine("Running Synchronize request to set sources")
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorId $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential}
```

Asynchronouse execution will speed up.

```PowerShell
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | Select -First 2

# Set Sources
$host.Ui.WriteVerboseLine("Running Asynchronize request to set sources")
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorId $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential -Async}
```

### Remove Source

You can set Remove for each Sources in Collectors.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $_.id

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id -Credential $credential}
```

Asynchronouse execution will speed up.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Asynchronize request")
$collectors = Get-PSSumoLogicApiCollector -Credential $credential -Async | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Asynchronize request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorId $_.id -Async

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Asynchronize request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id -Credential $credential -Async}
```
