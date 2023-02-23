targetScope = 'managementGroup'

// PARAMETERS
param initiativeName string
param policySource string
param policyCategory string = 'Custom'
param assignmentEnforcementMode string = 'Default'
param assignmentIdentityLocation string = 'westeurope'
param listOfAllowedLocations array = []
param storageAccountEffect string
param storageAccountAclEffect string
param keyVaultFirewallEffect string
param assignmentMG array
param exemptionMG array

// VARIABLES
var builtinRoles = json(loadTextContent('../Builtin_Role_Ids/builtinroles.json'))

// RESOURCES
module initiatives './mg_initiatives.bicep' = {
  name: 'initiatives'
  params: {
    initiativeName: initiativeName
    policySource: policySource
    policyCategory: policyCategory
    listOfAllowedLocations: listOfAllowedLocations
    storageAccountEffect: storageAccountEffect
    storageAccountAclEffect: storageAccountAclEffect
    keyVaultFirewallEffect: keyVaultFirewallEffect
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
    listOfAllowedLocations: listOfAllowedLocations
    storageAccountEffect: storageAccountEffect
    storageAccountAclEffect: storageAccountAclEffect
    keyVaultFirewallEffect: keyVaultFirewallEffect
    initiative1ID: initiatives.outputs.initiative1ID
  }
}]

//EXEMPTIONS
module exemptions0 '../modules/mg_exemptions.bicep' = {
  name: exemptionMG[0].exemptionDeploymentName
  scope: managementGroup(exemptionMG[0].mg)
  params: {
    exemptionPolicyAssignmentId: assignments1[0].outputs.policyAssignmentIds[0]
    policySource: policySource
    exemptionCategory: exemptionMG[0].exemptionCategory
    exemptionDisplayName: exemptionMG[0].exemptionDisplayName
    exemptionDeploymentName: exemptionMG[0].exemptionDeploymentName
    exemptionDescription: exemptionMG[0].exemptionDescription
    exemptionExpiryDate: exemptionMG[0].exemptionExpiryDate
    exemptionVersion: exemptionMG[0].exemptionVersion
  }
}
