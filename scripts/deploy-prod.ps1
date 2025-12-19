Param(
    [string]$ResourceGroup = "rg-ai-core",
    [string]$TemplateFile = "infra/core/main.bicep",
    [string]$ParamsFile = "infra/params/prod.json"
)

Write-Host "🚀 Deploying infrastructure to $ResourceGroup (Prod)..."

az deployment group create `
    --resource-group $ResourceGroup `
    --template-file $TemplateFile `
    --parameters @$ParamsFile

Write-Host "✅ Prod infrastructure deployed."

# Deploy specific agents for Prod environment
Get-ChildItem -Directory -Path "agents" | ForEach-Object {
    Write-Host "🚀 Deploying agent: $($_.Name) to Prod"
    python scripts/deploy_agent.py $_.Name
}
