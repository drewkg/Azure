Test-AzTemplate $PSScriptRoot -Pester -Skip "apiVersions Should Be Recent", "Location Should Not Be Hardcoded"

# apiVersions Should Be Recent, as issue in ARM-TTK for linked services.
# Location Should Not Be Hardcoded, as only allowed values so this test does not make sense.
