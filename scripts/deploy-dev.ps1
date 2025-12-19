#!/bin/bash

az deployment group create `
  --resource-group rg-ai-core `
  --template-file infra/core/main.bicep `
  --parameters @infra/params/dev.json
