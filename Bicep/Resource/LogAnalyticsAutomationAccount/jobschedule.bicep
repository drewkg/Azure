
param name string = newGuid()
param automationAccount string
param runbook string
param schedule string


resource UpdateAutomationAzureModulesForAccountJobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2022-08-08' = {
#disable-next-line use-stable-resource-identifiers
  name: name
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
