#!/usr/bin/env bash
set -e

# --- Configuration ---
RESOURCE_GROUP="rg-ai-core"
TEMPLATE_FILE="infra/core/main.bicep"
PARAMS_FILE="infra/params/dev.json"
ENVIRONMENT="dev"  # used in deploy_agent.py

# --- Deploy infrastructure ---
echo "🚀 Deploying infrastructure to $RESOURCE_GROUP..."
az group create --name "$RESOURCE_GROUP" --location australiaeast

az deployment group create \
  --resource-group "$RESOURCE_GROUP" \
  --template-file "$TEMPLATE_FILE" \
  --parameters @"$PARAMS_FILE"

echo "✅ Infrastructure deployed to $RESOURCE_GROUP"

# --- Deploy all agents ---
echo "📦 Deploying agents to $RESOURCE_GROUP..."
for agent in agents/*; do
  if [ -d "$agent" ]; then
    AGENT_NAME=$(basename "$agent")
    echo "Deploying agent: $AGENT_NAME"
    python scripts/deploy_agent.py "$AGENT_NAME" "$ENVIRONMENT"
  fi
done

echo "🧠 All agents deployed successfully to $RESOURCE_GROUP ✅"
