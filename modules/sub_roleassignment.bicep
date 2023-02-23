targetScope = 'subscription'

// PARAMETERS
param principalId string
param principalType string
param roleDefinitionId string

// ROLE ASSIGNMENTS - required for policy assignment managed identity to have permissions to assignment scope
resource policy_roleassignment 'Microsoft.Authorization/roleAssignments@2020-10-01-preview' = {
  name: guid(principalId,roleDefinitionId,subscription().id)
  properties: {
    principalId: principalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: roleDefinitionId
  }
}
