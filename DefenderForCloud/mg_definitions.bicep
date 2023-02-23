targetScope = 'managementGroup'

// VARIABLES
var deploy_mdc_security_contacts = json(loadTextContent('./Custom/deploy_mdc_security_contacts.json'))

// CUSTOM DEFINITIONS
resource deployMdcSecurityContacts 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'DeployMdcSecurityContacts'
  properties: deploy_mdc_security_contacts.properties
}

// OUTPUTS
output customPolicyIds array = [
  deployMdcSecurityContacts.id
]

output customPolicyNames array = [
  deployMdcSecurityContacts.properties.displayName
]
