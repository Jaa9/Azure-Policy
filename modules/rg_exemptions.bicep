targetScope = 'resourceGroup'

// PARAMETERS
param policySource string
param exemptionPolicyAssignmentId string
param exemptionCategory string
param exemptionExpiryDate string
param exemptionDisplayName string
param exemptionDeploymentName string
param exemptionDescription string
param exemptionVersion string
param exemptionPolicyDefinitionReferenceIds array

// RESOURCES
resource exemption_1 'Microsoft.Authorization/policyExemptions@2020-07-01-preview' = {
  name: exemptionDeploymentName
  properties: {
    policyAssignmentId: exemptionPolicyAssignmentId
    policyDefinitionReferenceIds: exemptionPolicyDefinitionReferenceIds
    exemptionCategory: exemptionCategory
    expiresOn: exemptionExpiryDate
    displayName: exemptionDisplayName
    description: exemptionDescription
    metadata: {
      version: exemptionVersion
      source: policySource
    }
  }
}

// OUTPUTS
output exemptionIds array = [
  exemption_1.id
]
