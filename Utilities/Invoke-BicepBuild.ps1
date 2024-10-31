Get-ChildItem -Path .\Bicep\ -Include main.bicep -Recurse -File
  | ForEach-Object {
      Write-Host "Linting bicep on Directory -" $_.Directory
      bicep lint $_.FullName
    }
