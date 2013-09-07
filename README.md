PS-SumoLogicAPI
==========

SumoLogic Collector management API Modules.

# SumoLogic Collector Management API

See here.

[SumoLogic/sumo-api-doc](https://github.com/SumoLogic/sumo-api-doc/wiki/collector-management-api)

# Cmdlets

Here's Cmdlets use in public

```text
CommandType Name                             ModuleName     
----------- ----                             ----------     
Function    Get-SumoLogicCollectors          PS-SumoLogicAPI
Function    Get-SumoLogicCollectorsSource    PS-SumoLogicAPI
Function    Get-SumoLogicCredential          PS-SumoLogicAPI
Function    New-SumoLogicCredential          PS-SumoLogicAPI
Function    Remove-SumoLogicCollectors       PS-SumoLogicAPI
Function    Remove-SumoLogicCollectorsSource PS-SumoLogicAPI
Function    Set-SumoLogicCollectorsSource    PS-SumoLogicAPI
```

# Sample

## Credential

### Create Credential secure Password File

```PowerShell
New-SumoLogicCredential -user hoge@hoge.com
```

### Get Credential secure Password from file

```PowerShell
Get-SumoLogicCredential -user hoge@hoge.com
```

you can reuse Credential.

```PowerShell
$credential = Get-SumoLogicCredential -user hoge@hoge.com
```


## Collector

### Get SumoLogic Collectors of your account

```PowerShell
Get-SumoLogicCollectors -Credential $credential
```

specify collector id
```PowerShell
Get-SumoLogicCollectors -CollectorIds "CollectorId" -Credential $credential
```

You can reuse collectors.

```PowerShell
$Collectors = Get-SumoLogicCollectors -Credential $credential
```

### Remove Collectors

Specify Collector id to remove collectors
```PowerShell
Remove-SumoLogicCollectors -CollectorIds $Collectors.id -Credential $credential
```
you can run as parallel for collectors by adding -parallel switch. (using workflow 5 parallel)
```PowerShell
Remove-SumoLogicCollectors -CollectorIds $Collectors.id -Credential $credential -parallel
```

## Source

### Get SumoLogic Source for Collectors of your account

Get all collectors source
```PowerShell
Get-SumoLogicCollectorsSource -CollectorIds $Collectors.id -Credential $credential -parallel | ft
```

Get Specific Collectors source
```PowerShell
Get-SumoLogicCollectorsSource -CollectorIds "collector id" -Credential $credential
```

Using <where> to specify source name
```PowerShell
Get-SumoLogicCollectorsSource -CollectorIds "collector id" -Credential $credential | where name -eq "test"
```
### Set SumoLogic Source for Collectors of your account

You can set for each Source Type, will show in intellisence.
```PowerShell
Set-SumoLogicCollectorsSource -CollectorIds "Collector id" -pathExpression "Path to Log" -name "Source name" -sourceType "Select from intellisence" -category "category name" -description "description" -Credential $credential
```

you can run as parallel for sources by adding -parallel switch. (using workflow 5 parallel)
```PowerShell
Set-SumoLogicCollectorsSource -CollectorIds "Collector id" -pathExpression "Path to Log" -name "Source name" -sourceType "Select from intellisence" -category "category name" -description "description" -Credential $credential -parallel
```

### Remove Source

Specify Collector id to remove Source
```PowerShell
Remove-SumoLogicCollectorsSource -CollectorId 4105438 -SourceIds $(Get-SumoLogicCollectorsSource -CollectorIds 4105438 -Credential $credential | where name -eq "test").id -Credential $credential -parallel
```

Or foreach collectors for specific source name.
```PowerShell
$collectors | %{
    $sourceids = Get-SumoLogicCollectorsSource -Credential $credential -CollectorIds $_.id | where name -like "$sourcename*"
    Remove-SumoLogicCollectorsSource -SourceIds $sourceids.id -CollectorId $_.id -Credential $credential -parallel
}
```
