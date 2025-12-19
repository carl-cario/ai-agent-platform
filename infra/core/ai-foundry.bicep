param location string
param aiFoundryName string

resource openai 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: aiFoundryName
  location: location
  kind: 'OpenAI'
  sku: {
    name: 'S0'
  }
  properties: {
    // Required property for OpenAI
    publicNetworkAccess: 'Enabled'
  }
}
