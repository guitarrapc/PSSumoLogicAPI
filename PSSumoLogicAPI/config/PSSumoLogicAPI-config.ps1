#-- Public Loading Module Parameters (Recommend to use ($PSSumoLogicAPI.defaultconfigurationfile) for customization) --#

# credential
$PSSumoLogicAPI.credential = @{
    user                        = "INPUT YOUR API KEY HERE"
}

# RunSpace Pool size
$PSSumoLogicAPI.runSpacePool = @{
    minPoolSize                    = 50
    maxPoolSize                    = 50
}
