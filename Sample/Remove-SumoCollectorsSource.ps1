# define
$user = "hoge@hoge.com"
$collectornames = "ServerName*"

$sourcename = $category = "sample"
$pathExpression = "c:\logs\hoge.log"
$description = "$sourcename description"


# Get Credential
$credential = Get-SumoCredential -User $user

# Get Collector
$collectors = Get-SumoApiCollectors -Credential $credential | where name -like $collectornames

# Get Source
Get-SumoApiCollectorsSource  -Credential $credential -CollectorIds $Collectors.id -parallel

# Set Source
Set-SumoApiCollectorsSource -CollectorIds $Collectors.id -sourceType LocalFile -pathExpression $pathExpression -name $sourcename -category $category -description $description -parallel -Credential $credential


# Remove Source
# parallel
$collectors | %{
    $sourceids = Get-SumoApiCollectorsSource -Credential $credential -CollectorIds $_.id | where name -like "$sourcename*"
    Remove-SumoApiCollectorsSource -SourceIds $sourceids.id -CollectorId $_.id -Credential $credential -parallel
}

# sequencial
$collectors | %{
    $sourceids = Get-SumoApiCollectorsSource -Credential $credential -CollectorIds $_.id | where name -like "$sourcename*"
    Remove-SumoApiCollectorsSource -SourceIds $sourceids.id -CollectorId $_.id -Credential $credential
}



