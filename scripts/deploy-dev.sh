#!/usr/bin/env bash
set -e

# --- Environment ---
ENVIRONMENT="dev"
RESOURCE_GROUP="rg-ai-core"
TEMPLATE_FILE="infra/core/main.bicep"
PARAMS_FILE="infra/params/dev.json"

# --- Azure login ---
echo "🔑 Logging in to Azure..."
az login --service-principal \
    -u $AZURE_CLIENT_ID \
    -p $AZURE_CLIENT_SECRET \
    --tenant $AZURE_TENANT_ID

az account set --subscription $AZURE_SUBSCRIPTION_ID

# --- Deploy infra ---
echo "🚀 Deploying Dev infrastructure..."
az group create --name "$RESOURCE_GROUP" --location australiaeast

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "$TEMPLATE_FILE" \
  --parameters @"$PARAMS_FILE"

echo "✅ Dev infrastructure deployed"

# --- Deploy agents ---
echo "📦 Deploying agents to Dev..."
for agent in agents/*; do
  if [ -d "$agent" ]; then
    AGENT_NAME=$(basename "$agent")
    echo "Deploying agent: $AGENT_NAME"
    python scripts/deploy_agent.py "$AGENT_NAME" "$ENVIRONMENT"
  fi
done

echo "🧠 Agents deployed to DEV successfully ✅"
