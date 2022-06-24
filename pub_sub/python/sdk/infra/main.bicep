targetScope = 'subscription'

@minLength(1)
@maxLength(64)
@description('Name of the the environment which is used to generate a short unqiue hash used in all resources.')
param name string

@minLength(1)
@description('Primary location for all resources')
param location string

@description('Id of the user or app to assign application roles')
param principalId string = ''

@description('The image name for the checkout service')
param checkoutImageName string = ''

@description('The image name for the order-processor service')
param orderprocessorImageName string = ''

resource resourceGroup 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${name}-rg'
  location: location
}

var resourceToken = toLower(uniqueString(subscription().id, name, location))
var tags = {
  'azd-env-name': name
}

module resources './resources.bicep' = {
  name: 'resources-${resourceToken}'
  scope: resourceGroup
  params: {
    name: name
    location: location
    principalId: principalId
    resourceToken: resourceToken
    apiImageName: checkoutImageName
    webImageName: orderprocessorImageName
    tags: tags
  }
}

output AZURE_KEY_VAULT_ENDPOINT string = resources.outputs.AZURE_KEY_VAULT_ENDPOINT
output SERVICEBUS_ENDPOINT string = resources.outputs.SERVICEBUS_ENDPONT
output APPINSIGHTS_INSTRUMENTATIONKEY string = resources.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
output AZURE_CONTAINER_REGISTRY_ENDPOINT string = resources.outputs.AZURE_CONTAINER_REGISTRY_ENDPOINT
output AZURE_CONTAINER_REGISTRY_NAME string = resources.outputs.AZURE_CONTAINER_REGISTRY_NAME
output APP_CHECKOUT_BASE_URL string = resources.outputs.CHECKOUT_APP_URI
output API_ORDER_BASE_URL string = resources.outputs.ORDER_API_URI
output APP_APPINSIGHTS_INSTRUMENTATIONKEY string = resources.outputs.APPINSIGHTS_INSTRUMENTATIONKEY
