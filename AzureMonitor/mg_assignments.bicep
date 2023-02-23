targetScope = 'managementGroup'

// PARAMETERS
param assignmentName string
param assignmentVersion string
param policySource string
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param logAnalytics string
param initiative1ID string
param userAssignedManagedIdentity string
param userAssignedManagedIdentityObjectId string
param keyVaultDiagLogsMatchWorkspace bool
param keyVaultDiagLogsEnabled string
param keyVaultDiagMetricsEnabled string
param keyVaultDiagProfileName string
param keyVaultDiagEffect string

// VARIABLES
var builtinRoles = json(loadTextContent('../Builtin_Role_Ids/builtinroles.json'))

// RESOURCES
resource assignment1 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: assignmentName
  location: assignmentIdentityLocation
  identity: {
    type: 'UserAssigned'
    userAssignedIdentities: {
      '${userAssignedManagedIdentity}': {}
    }
  }
  properties: {
    displayName: assignmentName
    description: '${assignmentName} via ${policySource}'
    enforcementMode: assignmentEnforcementMode
    metadata: {
      source: policySource
      version: assignmentVersion
    }
    policyDefinitionId: initiative1ID
    parameters: {
      logAnalytics: {
        value: logAnalytics
      }
      keyVaultDiagLogsMatchWorkspace:{
        value: keyVaultDiagLogsMatchWorkspace
      }
      keyVaultDiagLogsEnabled:{
        value: keyVaultDiagLogsEnabled
      }
      keyVaultDiagMetricsEnabled:{
        value: keyVaultDiagMetricsEnabled
      }
      keyVaultDiagProfileName:{
        value: keyVaultDiagProfileName
      }
      keyVaultDiagEffect:{
        value: keyVaultDiagEffect
      }
    }
  }
}

// OUTPUTS
output assignment1ID string = assignment1.id
output policyAssignmentIds array = [
  assignment1.id
]
