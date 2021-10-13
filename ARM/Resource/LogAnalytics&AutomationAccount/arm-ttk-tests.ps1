Test-AzTemplate $PSScriptRoot -Pester -Skip "Location Should Not Be Hardcoded", "apiVersions Should Be Recent"

# Location Should Not Be Hardcoded, as only allowed values so this test does not make sense.
# apiVersions Should Be Recent, as the latest none preview runbook api is over 2 years old.