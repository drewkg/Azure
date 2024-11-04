
param name string = newGuid()
param automationAccount string
param runbook string
param schedule string


resource UpdateAutomationAzureModulesForAccountJobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2023-11-01' = {
#disable-next-line use-stable-resource-identifiers
  name: '${automationAccount}/${name}'
  properties: {
    parameters: {
      ResourceGroupName: resourceGroup().name
      AutomationAccountName: automationAccount
    }
    runbook: {
      name: runbook
    }
    schedule: {
      name: schedule
    }
  }
}
