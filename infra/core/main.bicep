param location string

param storageName string
param keyVaultName string
param appInsightsName string
param appConfigName string
param aiFoundryName string

module storage './storage.bicep' = {
  name: 'storage'
  params: {
    location: location
    storageName: storageName
  }
}

module keyvault './keyvault.bicep' = {
  name: 'keyvault'
  params: {
    location: location
    keyVaultName: keyVaultName
  }
}

module appinsights './appinsights.bicep' = {
  name: 'appinsights'
  params: {
    location: location
    appInsightsName: appInsightsName
  }
}

module appconfig './appconfig.bicep' = {
  name: 'appconfig'
  params: {
    location: location
    appConfigName: appConfigName
  }
}

module aifoundry './ai-foundry.bicep' = {
  name: 'aifoundry'
  params: {
    location: location
    aiFoundryName: aiFoundryName
  }
}
