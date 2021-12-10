Test-AzTemplate $PSScriptRoot -Pester -Skip "apiVersions Should Be Recent"

# Disable ARM TTK due to a JSON parsing issue with nested templates.
# Disable apiVersions Should Be Recent - Due to a bug in ARM TTK for Diagnostic Settings