#-- Public Loading Module Parameters (Recommend to use ($PSSumoLogicAPI.defaultconfigurationfile) for customization) --#

# credential
$PSSumoLogicAPI.credential = @{
    user                           = "INPUT YOUR Email Address to logon"
}

$PSSumoLogicAPI.sourceParameter    = @{
    alive                          = [bool]$true
    states                         = [string]""
    automaticDateParsing           = [bool]$true
    timeZone                       = [string]"Asia/Tokyo"
    multilineProcessingEnabled     = [bool]$true
}

# RunSpace Pool size
$PSSumoLogicAPI.runSpacePool = @{
    minPoolSize                    = 50
    maxPoolSize                    = 50
}
