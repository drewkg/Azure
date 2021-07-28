Test-AzTemplate $PSScriptRoot -Pester -Skip "Resources Should Not Be Ambiguous"

# Resources Should Not Be Ambiguous - Due to a bug with nested templates and inner scope.
