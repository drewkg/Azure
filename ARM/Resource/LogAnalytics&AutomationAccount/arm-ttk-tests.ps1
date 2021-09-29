Test-AzTemplate $PSScriptRoot -Pester -Skip "Location Should Not Be Hardcoded", "DeploymentTemplate Must Not Contain Hardcoded Uri"

# Location Should Not Be Hardcoded, as only allowed values so this test does not make sense.
# DeploymentTemplate Must Not Contain Hardcoded Uri, this does not allow for URI's in params, known issue.