targetScope = 'managementGroup'

// PARAMETERS
param assignmentName string
param assignmentVersion string = '1.0.0'
param policySource string
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param listOfAllowedLocations array
param storageAccountEffect string
param storageAccountAclEffect string
param keyVaultFirewallEffect string
param initiative1ID string

// VARIABLES
var builtinRoles = json(loadTextContent('../Builtin_Role_Ids/builtinroles.json'))

// RESOURCES
resource assignment1 'Microsoft.Authorization/policyAssignments@2021-06-01' = {
  name: assignmentName
  location: assignmentIdentityLocation
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
      listOfAllowedLocations: {
        value: listOfAllowedLocations
      }
      storageAccountEffect:{
        value: storageAccountEffect
      }
      storageAccountAclEffect:{
        value: storageAccountAclEffect
      }
      keyVaultFirewallEffect:{
        value: keyVaultFirewallEffect
      }
    }
    nonComplianceMessages: [
      {
        message: 'Company Policy Enforcement: Your resource deployment is not compliant with the ${assignmentName} policy. Only a predefined set of Azure regions are allowed for resource deployment. ${listOfAllowedLocations}'
        policyDefinitionReferenceId: 'AllowedLocations'
      }
      {
        message: 'Company Policy Enforcement: Your resource deployment is not compliant with the ${assignmentName} policy. Storage Accounts must be configured to accept requests only from secure connections (HTTPS).'
        policyDefinitionReferenceId: 'StorageAccountEnryptedCommunication'
      }
      {
        message: 'Company Policy Enforcement: Your resource deployment is not compliant with the ${assignmentName} policy. Storage Accounts must be configured to accept requests from specified networks.'
        policyDefinitionReferenceId: 'StorageAccountNetworkAcl'
      }
      {
        message: 'Company Policy Enforcement: Your resource deployment is not compliant with the ${assignmentName} policy. KeyVault must be configured with firewall rules.'
        policyDefinitionReferenceId: 'KeyVaultFirewall'
      }
    ]
  }
}

// OUTPUTS
output assignment1ID string = assignment1.id
output policyAssignmentIds array = [
  assignment1.id
]
