#!/usr/bin/env bash
set -e

ENVIRONMENT="test"
RESOURCE_GROUP="rg-ai-core"
TEMPLATE_FILE="infra/core/main.bicep"
PARAMS_FILE="infra/params/test.json"

# Azure login
az login --service-principal `
    -u $AZURE_CLIENT_ID `
    -p $AZURE_CLIENT_SECRET `
    --tenant $AZURE_TENANT_ID

az account set --subscription $AZURE_SUBSCRIPTION_ID

# Deploy infra
az group create --name "$RESOURCE_GROUP" --location australiaeast

az deployment group create `
  --resource-group "$RESOURCE_GROUP" `
  --template-file "$TEMPLATE_FILE" `
  --parameters @"$PARAMS_FILE"

echo "✅ Test infrastructure deployed"

# Deploy agents
for agent in agents/*; do
  if [ -d "$agent" ]; then
    AGENT_NAME=$(basename "$agent")
    python scripts/deploy_agent.py "$AGENT_NAME" "$ENVIRONMENT"
  fi
done

echo "🧠 Agents deployed to TEST successfully ✅"
