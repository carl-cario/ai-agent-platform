param location string
param appConfigName string

resource appconfig 'Microsoft.AppConfiguration/configurationStores@2022-05-01' = {
  name: appConfigName
  location: location
  sku: {
    name: 'developer'
  }
  properties: {
    disableLocalAuth: true
    softDeleteRetentionInDays: 0
  }
}
