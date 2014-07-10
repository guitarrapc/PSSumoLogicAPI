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

|CommandType|Name|ModuleName|
|----|----|----|
|Function|    Get-PSSumoLogicApiCollector          |PSSumoLogicApi|
|Function|    Get-PSSumoLogicApiCollectorSource    |PSSumoLogicApi|
|Function|    Get-PSSumoLogicApiCredential         |PSSumoLogicApi|
|Function|    Get-PSSumoLogicApiWebSession         |PSSumoLogicApi|
|Function|    New-PSSumoLogicApiCredential         |PSSumoLogicApi|
|Function|    Remove-PSSumoLogicApiCollector       |PSSumoLogicApi|
|Function|    Remove-PSSumoLogicApiCollectorSource |PSSumoLogicApi|
|Function|    Set-PSSumoLogicApiCollectorSource    |PSSumoLogicApi|
|Function|    Update-PSSumoLogicApiCollectorSource |PSSumoLogicApi|


# Test

You can find sample source in [Test](https://github.com/guitarrapc/PSSumoLogicAPI/tree/master/PSSumoLogicAPI/Test)

## Credential

Make sure SumoLogicAPI requires credential authentication for only first session.
You will retrieve authenticated cookies when sending any API request with UserName/Password.
Use this authenticated cookies as WebSession then you do not need to pass credential afterward.

Make sure there is API limitation to try call API with credential, to retrieve websession/cookies.
If you call API for continuous 15 times, then you will be rejected from API for 60 sec.

### Create Credential secure Password File

The Credential will be save in Windows Credential Manager as Generic, Name with PSSumoLogicAPI.

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


### Get Credential secure Password from Windows Credential Manager

Once you create credential, you can get it easily.

This checking Credential Manager for the name with PSSumoLogicAPI. 

```PowerShell
Get-PSSumoLogicApiCredential
```

you can reuse Credential.

```PowerShell
$credential = Get-PSSumoLogicApiCredential
```

## Web Session

Before starting call SumoLogic API, set authenticated websessions to $PSSumoLogicAPI.Websession module variable.
After set this session, you can ignore any credential/session when call API.

### Set Authenticated cookies to $PSSumoLogicAPI.Websession

Get crednetial when obtain Websession.

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential
```

Then call SumoLogic API to get Web Session. If you add -PassThru switch, then retrived value will show in host.

```PowerShell
# Obtain Session Variables
$host.Ui.WriteVerboseLine("Get Sessionvariables and PassThru")
Get-PSSumoLogicApiWebSession -PassThru
```

Web Session value in contains in Module variable $PSSumoLogicAPI.WebSession.

```Powershell
$host.Ui.WriteVerboseLine("Output whether session contains in PSSumoLogicAPI variable.")
$PSSumoLogicAPI.WebSession
```

## Collector

### Get SumoLogic Collectors of your account

Now you can call SumoLogicAPI.

```PowerShell
$Collectors = Get-PSSumoLogicApiCollectors
$Collectors
```

specify collector ids.

```PowerShell
# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
Get-PSSumoLogicApiCollector -Id ($collectors.Id | select -First 5)
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.

```PowerShell
# Obtain each Collectors for first 5
$host.Ui.WriteVerboseLine("Running Asynchronous request for each CollectorId")
Get-PSSumoLogicApiCollector -Id ($collectors.Id | select -First 5) -Async -Verbose
```

It will speed up about 2-10 times then synchronous each collector id calls.

### Remove Collectors

Specify Collector id to remove collectors.

```PowerShell
# Remove each Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.
Asynchronouse execution will speed up.

```PowerShell
# Obtain each Collectors
$host.Ui.WriteVerboseLine("Running Asynchronous request for each collectorId to remove collectors")
Remove-PSSumoLogicApiCollector -Id $Collectors.id -Async
```

It may good to filter Collector name, OS or status to select which collector to delete.
Where-Object or .Where({}) will ease you filtering object.

## Source

### Get Collector Source

Get all collectors source.

```PowerShell
# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -CollectorId $collectors.id -Verbose
```

Get First 4 Collectors source.

```PowerShell
# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
Get-PSSumoLogicApiCollectorSource -CollectorId $collectors.id -Verbose
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.
Asynchronouse execution will speed up for 2-10 times then synchronous call.

```PowerShell
$host.Ui.WriteVerboseLine("Running Asynchronous request to get sources")
Get-PSSumoLogicApiCollectorSource -CollectorId $collectors.id -Async -Verbose
```

### Set SumoLogic Source for Collectors of your account

You can set for each Source Type, will show in intellisence.

```PowerShell
# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector | Select -First 2

# Set Sources
$host.Ui.WriteVerboseLine("Running Synchronize request to set sources")
$param = @{
    Id             = $Collectors.Id
    pathExpression = "C:\logs\Log.log"
    name           = "Log"
    sourceType     = "LocalFile"
    category       = "Log Category"
    description    = "Log Description"
}
Set-PSSumoLogicApiCollectorSource @param -Verbose
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.
Asynchronouse execution will speed up for 2-10 times then synchronous call.

```PowerShell
# Set Sources
$host.Ui.WriteVerboseLine("Running Asynchronous request to set sources")
$param = @{
    Id             = $Collectors.Id
    pathExpression = "C:\logs\Log.log"
    name           = "Log"
    sourceType     = "LocalFile"
    category       = "Log Category"
    description    = "Log Description"
}
Set-PSSumoLogicApiCollectorSource @param -Async -Verbose
```

### Remove Source

You can set Remove for each Sources in Collectors.

```PowerShell
# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request to get collectors")
$collectors = Get-PSSumoLogicApiCollector | select -First 5

# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Synchronize request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -CollectorId $_.id | where Name -eq "Log"

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Synchronize request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id}
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.
Asynchronouse execution will speed up for 2-10 times then synchronous call.

```PowerShell
# obtain Sources and remove it
$collectors `
| %{
    $host.Ui.WriteVerboseLine("Running Asynchronous request to get sources")
    $souces = Get-PSSumoLogicApiCollectorSource -CollectorId $_.id -Async

    # Remove each souces in per Collectors
    $host.Ui.WriteVerboseLine("Running Asynchronous request for each collectorId")
    Remove-PSSumoLogicApiCollectorSource -CollectorId $_.id -Id $souces.id -Async}
```
