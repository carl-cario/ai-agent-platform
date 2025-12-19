$ErrorActionPreference = "Stop"

$RESOURCE_GROUP = "rg-ai-core"
$TEMPLATE = "infra/core/main.bicep"
$PARAMS = "infra/params/dev.json"

Write-Host "Deploying DEV infrastructure..."

az deployment group create `
  --name dev-deploy `
  --resource-group $RESOURCE_GROUP `
  --template-file $TEMPLATE `
  --parameters @$PARAMS

Write-Host "Infrastructure deployed."

Write-Host "Deploying agents..."
Get-ChildItem agents -Directory | ForEach-Object {
  python scripts/deploy_agent.py $_.Name dev
}
