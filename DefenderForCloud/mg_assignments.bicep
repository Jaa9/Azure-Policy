targetScope = 'managementGroup'

// PARAMETERS
param assignmentName string
param assignmentVersion string
param policySource string
param assignmentIdentityLocation string
param assignmentEnforcementMode string
param userAssignedManagedIdentity string
param defenderForServerEffect string
param defenderForKeyVaultEffect string
param defenderForDNSEffect string
param defenderForRgEffect string
param defenderForStorageEffect string
param defenderForCSPMEffect string
param initiative1ID string
param vulnerabilityAssessmentEffect string
param vaType string
param emailSecurityContact string
param mdcSecurityContactEffect string
param minimalSeverity string

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
      defenderForServerEffect: {
        value: defenderForServerEffect
      }
      defenderForKeyVaultEffect: {
        value: defenderForKeyVaultEffect
      }
      defenderForDNSEffect: {
        value: defenderForDNSEffect
      }
      defenderForRgEffect: {
        value: defenderForRgEffect
      }
      defenderForStorageEffect: {
        value: defenderForStorageEffect
      }
      defenderForCSPMEffect: {
        value: defenderForCSPMEffect
      }
      vulnerabilityAssessmentEffect:{
        value: vulnerabilityAssessmentEffect
      }
      vaType:{
        value: vaType
      }
      emailSecurityContact: {
        value: emailSecurityContact
      }
      mdcSecurityContactEffect:{
        value: mdcSecurityContactEffect
      }
      minimalSeverity:{
        value: minimalSeverity
      }
    }
  }
}

// OUTPUTS
output assignment1ID string = assignment1.id
output policyAssignmentIds array = [
  assignment1.id
]
