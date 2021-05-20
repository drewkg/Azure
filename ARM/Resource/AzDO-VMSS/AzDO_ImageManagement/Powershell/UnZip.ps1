Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory('C:\\BuildArtifacts\\drivetrainwinps.zip', 'C:\\BuildArtifacts')