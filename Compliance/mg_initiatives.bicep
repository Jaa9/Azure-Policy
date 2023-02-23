targetScope = 'managementGroup'

// PARAMETERS
param policySource string
param policyCategory string
param listOfAllowedLocations array
param storageAccountEffect string
param storageAccountAclEffect string
param keyVaultFirewallEffect string
param initiativeName string

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
      version: '0.1.0'
    }
    parameters: {
      listOfAllowedLocations: {
        type: 'Array'
        metadata: ({
          description: 'This policy enables you to restrict the locations your organization can specify when deploying resources. Use to enforce your geo-compliance requirements. Excludes resource groups, Microsoft.AzureActiveDirectory/b2cDirectories, and resources that use the global region.'
          strongtype: 'location'
          displayName: 'Allowed locations'
        })
      }
      storageAccountEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
      storageAccountAclEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }
      keyVaultFirewallEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Audit'
      }      
    }
    policyDefinitions: [
      {
        //Specify locations allowed for resource deplyment
        policyDefinitionId: builtinPolicies1.AllowedLocations
        policyDefinitionReferenceId: 'AllowedLocations'
        parameters: {
          listOfAllowedLocations:{
            value: '[parameters(\'listOfAllowedLocations\')]'
          }
        }
      }
      {
        //Secure transfer to storage accounts should be enabled
        policyDefinitionId: builtinPolicies1.SecureTransferToStorageAccountsShouldBeEnabled
        policyDefinitionReferenceId: 'StorageAccountEnryptedCommunication'
        parameters: {
          Effect:{
            value: '[parameters(\'storageAccountEffect\')]'
          }
        }
      }
      {
        //Storage accounts should restrict network access
        policyDefinitionId: builtinPolicies1.StorageAccountsShouldRestrictNetworkAccess
        policyDefinitionReferenceId: 'StorageAccountNetworkAcl'
        parameters: {
          Effect:{
            value: '[parameters(\'storageAccountAclEffect\')]'
          }
        }
      }
      {
        //Azure Key Vault should have firewall enabled
        policyDefinitionId: builtinPolicies1.AzureKeyVaultShouldHaveFirewallEnabled
        policyDefinitionReferenceId: 'KeyVaultFirewall'
        parameters: {
          Effect:{
            value: '[parameters(\'keyVaultFirewallEffect\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output initiative1ID string = initiative1.id


