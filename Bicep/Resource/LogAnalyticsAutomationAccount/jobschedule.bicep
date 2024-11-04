param automationAccount string
param runbook string
param schedule string

resource UpdateAutomationAzureModulesForAccountJobSchedule 'Microsoft.Automation/automationAccounts/jobSchedules@2023-11-01' = {
  name: guid('${automationAccount}/${runbook}/${schedule}')
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
