Test-AzTemplate $PSScriptRoot -Pester -Skip "Template Should Not Contain Blanks"

# Template Should Not Contain Blanks - Due to a bug with nested templates and inner scope.
