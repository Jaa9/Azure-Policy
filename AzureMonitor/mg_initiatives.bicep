targetScope = 'managementGroup'

// PARAMETERS
param policySource string
param policyCategory string
param logAnalytics string
param initiativeName string
param keyVaultDiagLogsMatchWorkspace bool
param keyVaultDiagLogsEnabled string
param keyVaultDiagMetricsEnabled string
param keyVaultDiagProfileName string
param keyVaultDiagEffect string


// VARIABLES
var builtinPolicies1 = json(loadTextContent('../Builtin_Policy_Ids/builtin.json'))

// RESOURCES
resource initiative1 'Microsoft.Authorization/policySetDefinitions@2020-09-01' = {
  name: initiativeName
  properties: {
    policyType: 'Custom'
    displayName: initiativeName
    description: '${initiativeName} via ${policySource}'
    metadata: {
      category: policyCategory
      source: policySource
      version: '1.0.0'
    }
    parameters: {
      logAnalytics: {
        type: 'String'
        metadata: ({
          description: 'Specify the Log Analytics workspace the agent should be connected to. If this workspace is outside of the scope of the assignment you must manually grant \'Log Analytics Contributor\' permissions (or similar) to the policy assignment\'s principal ID'
          strongtype: 'omsWorkspace'
          displayName: 'Log Analytics workspace'
          assignPermissions: true
        })
      }
      keyVaultDiagLogsMatchWorkspace: {
        type: 'Boolean'
        metadata: {
          displayName: 'Workspace id must match'
          description: 'Whether to require that the workspace of the diagnostic settings matches the workspace deployed by this policy'
        }
        allowedValues: [
          true
          false
        ]
        defaultValue: false
      }
      keyVaultDiagLogsEnabled: {
        type: 'String'
        metadata: {
          displayName: 'Enable logs'
          description: 'Whether to enable logs stream to the Log Analytics workspace - True or False'
        }
        allowedValues: [
          'True'
          'False'
        ]
        defaultValue: 'True'
      }
      keyVaultDiagMetricsEnabled: {
        type: 'String'
        metadata: {
          displayName: 'Enable metrics'
          description: 'Whether to enable metrics stream to the Log Analytics workspace - True or False'
        }
        allowedValues: [
          'True'
          'False'
        ]
        defaultValue: 'True'
      }
      keyVaultDiagProfileName: {
        type: 'String'
        metadata: {
          displayName: 'Profile name'
          description: 'The diagnostic settings profile name'
        }
        defaultValue: 'setbypolicy_logAnalytics'
      }
      keyVaultDiagEffect: {
        type: 'String'
        metadata: {
          displayName: 'Effect'
          description: 'Enable or disable the execution of the policy'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }

    }
    policyDefinitions: [
      {
        //Deploy Diagnostic Settings for Key Vault to Log Analytics workspace
        policyDefinitionId: builtinPolicies1.DeployDiagnosticSettingsForKeyVaultToLogAnalyticsWorkspace
        policyDefinitionReferenceId: 'DeployDiagnosticSettingsForKeyVaultToLogAnalyticsWorkspace'
        parameters: {
          matchWorkspace:{
            value: '[parameters(\'keyVaultDiagLogsMatchWorkspace\')]'
          }
          logsEnabled:{
            value: '[parameters(\'keyVaultDiagLogsEnabled\')]'
          }
          metricsEnabled:{
            value: '[parameters(\'keyVaultDiagMetricsEnabled\')]'
          }
          logAnalytics:{
            value: '[parameters(\'logAnalytics\')]'
          }
          profileName:{
            value: '[parameters(\'keyVaultDiagProfileName\')]'
          }
          effect:{
            value: '[parameters(\'keyVaultDiagEffect\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output initiative1ID string = initiative1.id


