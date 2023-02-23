targetScope = 'managementGroup'

// PARAMETERS
param policySource string
param policyCategory string
param initiativeName string
param assignmentEnforcementMode string
param assignmentIdentityLocation string
param logAnalytics string
param logAnalyticsSubscriptionId string
param logAnalyticsRG string
param assignmentRG array
param assignmentMG array
param exemptionMG array
param userAssignedManagedIdentity string
param userAssignedManagedIdentityObjectId string
param keyVaultDiagLogsMatchWorkspace bool
param keyVaultDiagLogsEnabled string
param keyVaultDiagMetricsEnabled string
param keyVaultDiagProfileName string
param keyVaultDiagEffect string

// VARIABLES
var builtinRoles = json(loadTextContent('../Builtin_Role_Ids/builtinroles.json'))

// POLICY DEFINITIONS MODULE

// RESOURCES
module initiatives './mg_initiatives.bicep' = {
  name: 'initiatives'
  params: {
    initiativeName: initiativeName
    policySource: policySource
    policyCategory: policyCategory
    logAnalytics: logAnalytics
    keyVaultDiagLogsMatchWorkspace: keyVaultDiagLogsMatchWorkspace
    keyVaultDiagLogsEnabled: keyVaultDiagLogsEnabled
    keyVaultDiagMetricsEnabled: keyVaultDiagMetricsEnabled
    keyVaultDiagProfileName:keyVaultDiagProfileName
    keyVaultDiagEffect: keyVaultDiagEffect
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
    logAnalytics: logAnalytics
    initiative1ID: initiatives.outputs.initiative1ID
    userAssignedManagedIdentity: userAssignedManagedIdentity
    userAssignedManagedIdentityObjectId: userAssignedManagedIdentityObjectId
    keyVaultDiagLogsMatchWorkspace: keyVaultDiagLogsMatchWorkspace
    keyVaultDiagLogsEnabled: keyVaultDiagLogsEnabled
    keyVaultDiagMetricsEnabled: keyVaultDiagMetricsEnabled
    keyVaultDiagProfileName:keyVaultDiagProfileName
    keyVaultDiagEffect: keyVaultDiagEffect
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
    roleDefinitionId: builtinRoles.Contributor
  }
}]

// ROLE ASSIGNMENTS - required for policy assignment managed identity to have permissions to Log Analytics Workspace for onboarding Virtual Machines
module law_roleassignment1 '../modules/rg_roleassignment.bicep' =  {
  name: 'lawpolicyroleassignment'
  scope: resourceGroup(logAnalyticsSubscriptionId,logAnalyticsRG)
  params: {
    principalId: userAssignedManagedIdentityObjectId
    principalType: 'ServicePrincipal'
    roleDefinitionId: builtinRoles.LogAnalyticsContributor
  }
}
