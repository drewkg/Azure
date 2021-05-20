Import-Module Az


New-AzResourceGroupDeployment -Name "deployment3" `
                              -ResourceGroupName rg-azvmss-temp `
                              -Mode Incremental `
                              -DeploymentDebugLogLevel All `
                              -TemplateFile C:\Users\siazh\code\drivetrain\AzDO_AgentEnvironment\azdo-agents-pool.json `
                              -adminPassword (ConvertTo-SecureString "334mfff@@5%34444" -AsPlainText -Force)