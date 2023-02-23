targetScope = 'managementGroup'

// PARAMETERS
param policySource string
param policyCategory string
param customPolicyIds array
param customPolicyNames array
param defenderForServerEffect string
param defenderForKeyVaultEffect string
param defenderForDNSEffect string
param defenderForRgEffect string
param defenderForStorageEffect string
param defenderForCSPMEffect string
param initiativeName string
param vulnerabilityAssessmentEffect string
param vaType string
param emailSecurityContact string
param mdcSecurityContactEffect string
param minimalSeverity string

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
      defenderForServerEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      defenderForKeyVaultEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      defenderForDNSEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      defenderForRgEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      defenderForStorageEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      defenderForCSPMEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      vulnerabilityAssessmentEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      vaType: {
        type: 'String'
        metadata: {
          description: 'Select the vulnerability assessment solution to provision to machines.'
          displayName: 'Vulnerability assessment provider type'
        }
        allowedValues: [
          'default'
          'mdeTvm'
        ]
        defaultValue: 'default'
      }
      emailSecurityContact: {
        type: 'String'
        metadata: {
          description: 'Provide email address for Azure Security Center contact details'
          displayName: 'Security contacts email address'
        }
        defaultValue: 'ae.ict.security.incident@ae.no'
      }
      mdcSecurityContactEffect: {
        type: 'String'
        metadata: {
          description: 'The effect determines what happens when the policy rule is evaluated to match'
          displayName: 'Effect'
        }
        allowedValues: [
          'DeployIfNotExists'
          'Disabled'
        ]
        defaultValue: 'Disabled'
      }
      minimalSeverity: {
        type: 'String'
        metadata: {
          description: 'Defines the minimal alert severity which will be sent as email notifications'
          displayName: 'Minimal severity'
        }
        allowedValues: [
          'High'
          'Medium'
          'Low'
        ]
        defaultValue: 'High'
      }
    }
    policyDefinitions: [
      {
        //Deploy Defender for Cloud for Server Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureAzureDefenderForServersToBeEnabled
        policyDefinitionReferenceId: 'DefenderForServers'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForServerEffect\')]'
          }
        }
      }
      {
        //Deploy Defender for Cloud for Key Vaults Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureAzureDefenderForKeyVaultsToBeEnabled
        policyDefinitionReferenceId: 'DefenderForKeyVault'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForKeyVaultEffect\')]'
          }
        }
      }
      {
        //Deploy Defender for Cloud for DNS Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureAzureDefenderForDNSToBeEnabled
        policyDefinitionReferenceId: 'DefenderForDNS'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForDNSEffect\')]'
          }
        }
      }
      {
        //Deploy Defender for Cloud for ResourceGroup Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureAzureDefenderForResourceManagerToBeEnabled
        policyDefinitionReferenceId: 'DefenderForRg'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForRgEffect\')]'
          }
        }
      }
      {
        //Deploy Defender for Cloud for Storage Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureAzureDefenderForStorageToBeEnabled
        policyDefinitionReferenceId: 'DefenderForStorage'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForStorageEffect\')]'
          }
        }
      }
      {
        //Deploy Defender for Cloud Security Posture Management Settings to Subscriptions
        policyDefinitionId: builtinPolicies1.ConfigureMicrosoftDefenderCSPMToBeEnabled
        policyDefinitionReferenceId: 'DefenderForCSPM'
        parameters: {
          Effect:{
            value: '[parameters(\'defenderForCSPMEffect\')]'
          }
        }
      }
      {
        //Configure machines to receive a vulnerability assessment provider
        policyDefinitionId: builtinPolicies1.ConfigureMachinesToReceiveAVulnerabilityAssessmentProvider
        policyDefinitionReferenceId: 'ConfigureMachinesToReceiveAVulnerabilityAssessmentProvider'
        parameters: {
          Effect:{
            value: '[parameters(\'vulnerabilityAssessmentEffect\')]'
          }
          vaType:{
            value: '[parameters(\'vaType\')]'
          }
        }
      }
      {
        //Deploy Microsoft Defender for Cloud Security Contacts
        policyDefinitionId: customPolicyIds[0]
        policyDefinitionReferenceId: 'DeployMdcSecurityContacts'
        parameters: {
          emailSecurityContact:{
            value: '[parameters(\'emailSecurityContact\')]'
          }
          effect:{
            value: '[parameters(\'mdcSecurityContactEffect\')]'
          }
          minimalSeverity:{
            value: '[parameters(\'minimalSeverity\')]'
          }
        }
      }
    ]
  }
}

// OUTPUTS
output initiative1ID string = initiative1.id
