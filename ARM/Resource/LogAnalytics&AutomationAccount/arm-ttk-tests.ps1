Test-AzTemplate $PSScriptRoot -Pester -Skip "Location Should Not Be Hardcoded"

# Location Should Not Be Hardcoded, as only allowed values so this test does not make sense.