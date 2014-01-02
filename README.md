PS-SumoLogicAPI
==========

SumoLogic Collector management API Modules.

# SumoLogic Collector Management API

See here.

[SumoLogic/sumo-api-doc](https://github.com/SumoLogic/sumo-api-doc/wiki/collector-management-api)

# Cmdlets

Here's Cmdlets use in public

```text
CommandType Name                                               ModuleName    
----------- ----                                               ----------    
Function    Get-PSSumoLogicApiCollectorAsyncResult             PSSumoLogicAPI
Function    Get-PSSumoLogicApiCollectors                       PSSumoLogicAPI
Function    Get-PSSumoLogicApiCollectorSource                  PSSumoLogicAPI
Function    Get-PSSumoLogicApiCredential                       PSSumoLogicAPI
Function    Invoke-PSSumoLogicApiInvokeCollectorAsync          PSSumoLogicAPI
Function    Invoke-PSSumoLogicApiInvokeCollectorSourceAsync    PSSumoLogicAPI
Function    New-PSSumoLogicApiCredential                       PSSumoLogicAPI
Function    New-PSSumoLogicApiRunSpacePool                     PSSumoLogicAPI
Function    Remove-PSSumoLogicApiCollectors                    PSSumoLogicAPI
Function    Remove-PSSumoLogicApiCollectorsAsync               PSSumoLogicAPI
Function    Set-PSSumoLogicApiCollectorSource                  PSSumoLogicAPI
Function    Test-IsPSSumoLogicApiCollectorAsyncStatusCompleted PSSumoLogicAPI
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
    user                        = "INPUT YOUR API KEY HERE"
}

#change it like

$PSSumoLogicAPI.credential = @{
    user                        = "hoge@hoge.com"
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
Get-PSSumoLogicApiCollectors -Credential $credential -CollectorIds "collectorId"
```

for multiple collectorIds, you can use -Async switch to invoke command asynchronous.

```PowerShell
Get-PSSumoLogicApiCollectors -Credential $credential -CollectorIds "collectorId" -Async
```

it will speed up about x5 then not using switch.

### Remove Collectors

Specify Collector id to remove collectors

```PowerShell
Remove-PSSumoLogicApiCollectors -CollectorIds $Collectors.id -Credential $credential
```

Asynchronouse execution will speed up
```PowerShell
Remove-PSSumoLogicApiCollectors -CollectorIds $Collectors.id -Credential $credential -Async
```

## Source

### Get SumoLogic Source for Collectors of your account

Get all collectors source
```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $collectors.id
```

Get First 4 Collectors source

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential | select -First 4

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $collectors.id
```

Asynchronouse execution will speed up

```PowerShell
# Get Credential
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$host.Ui.WriteVerboseLine("Running Synchronize request")
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential

# Obtain Source
$host.Ui.WriteVerboseLine("Running Synchronize request")
Get-PSSumoLogicApiCollectorSource -Credential $credential -CollectorIds $collectors.id -Async
```

### Set SumoLogic Source for Collectors of your account

You can set for each Source Type, will show in intellisence.
```PowerShell
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential | Select -First 2

# Set Sources
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorIds $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential}
```

Asynchronouse execution will speed up

```PowerShell
$credential = Get-PSSumoLogicApiCredential

# Obtain Collectors
$collectors = Get-PSSumoLogicApiCollectors -Credential $credential | Select -First 2

# Set Sources
,("Log","C:\logs\Log.log","Log Description") | %{Set-SumoLogicApiCollectorSource -CollectorIds $Collectors.Id -pathExpression $_[1] -name $_[0] -sourceType LocalFile -category $_[0] -description $_[2] -Credential $credential -Async}
```

### Remove Source

Will be create.