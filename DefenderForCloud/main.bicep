targetScope = 'managementGroup'

// PARAMETERS
param initiativeName string
param policySource string
param policyCategory string
param assignmentEnforcementMode string
param assignmentIdentityLocation string = 'westeurope'
param defenderForServerEffect string
param defenderForKeyVaultEffect string
param defenderForDNSEffect string
param defenderForRgEffect string
param defenderForStorageEffect string
param defenderForCSPMEffect string
param assignmentMG array
param userAssignedManagedIdentity string
param userAssignedManagedIdentityObjectId string
param exemptionMG array
param vulnerabilityAssessmentEffect string
param vaType string
param emailSecurityContact string
param mdcSecurityContactEffect string
param minimalSeverity string

// VARIABLES
var builtinRoles = json(loadTextContent('../Builtin_Role_Ids/builtinroles.json'))

// POLICY DEFINITIONS MODULE
module mg_definitions './mg_definitions.bicep' = {
  name: 'mg_definitions'
}

// RESOURCES
module initiatives './mg_initiatives.bicep' = {
  name: 'initiatives'
  params: {
    initiativeName: initiativeName
    policySource: policySource
    policyCategory: policyCategory
    customPolicyIds: mg_definitions.outputs.customPolicyIds
    customPolicyNames: mg_definitions.outputs.customPolicyNames
    defenderForServerEffect: defenderForServerEffect
    defenderForKeyVaultEffect: defenderForKeyVaultEffect
    defenderForDNSEffect: defenderForDNSEffect
    defenderForRgEffect: defenderForRgEffect
    defenderForStorageEffect: defenderForStorageEffect
    defenderForCSPMEffect: defenderForCSPMEffect
    vulnerabilityAssessmentEffect: vulnerabilityAssessmentEffect
    vaType: vaType
    emailSecurityContact: emailSecurityContact
    mdcSecurityContactEffect: mdcSecurityContactEffect
    minimalSeverity: minimalSeverity
  }
}

//ASSIGNMENTS
module assignments1 './mg_assignments.bicep' = [for MG in assignmentMG: {
  name: MG.assignmentName
  scope: managementGroup(MG.mg)
  params: {
    assignmentName: MG.assignmentDisplayName
    assignmentVersion: MG.assignmentVersion
    policySource: policySource
    assignmentIdentityLocation: assignmentIdentityLocation
    assignmentEnforcementMode: assignmentEnforcementMode
    userAssignedManagedIdentity: userAssignedManagedIdentity
    defenderForServerEffect: defenderForServerEffect
    defenderForKeyVaultEffect: defenderForKeyVaultEffect
    defenderForDNSEffect: defenderForDNSEffect
    defenderForRgEffect: defenderForRgEffect
    defenderForStorageEffect: defenderForStorageEffect
    defenderForCSPMEffect: defenderForCSPMEffect
    initiative1ID: initiatives.outputs.initiative1ID
    vulnerabilityAssessmentEffect: vulnerabilityAssessmentEffect
    vaType: vaType
    emailSecurityContact: emailSecurityContact
    mdcSecurityContactEffect: mdcSecurityContactEffect
    minimalSeverity: minimalSeverity
  }
}]

//EXEMPTIONS

// ROLE ASSIGNMENTS - required for policy assignment managed identity to have permissions to assignment scope
module defender_roleassignment1 '../modules/mg_roleassignment.bicep' =  [for MG in assignmentMG: {
  name: MG.roleAssignmentName
  scope: managementGroup(MG.mg)
  params: {
    principalId: userAssignedManagedIdentityObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: builtinRoles.SecurityAdmin
  }
}]
