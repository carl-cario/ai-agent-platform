#!/usr/bin/env bash

set -e

AGENT_NAME=$1

if [ -z "$AGENT_NAME" ]; then
  echo "❌ Usage: ./scripts/create-new-agent.sh <agent-name>"
  exit 1
fi

if [[ ! "$AGENT_NAME" =~ ^[a-z0-9-]+$ ]]; then
  echo "❌ Agent name must be lowercase and use hyphens only"
  exit 1
fi

AGENT_DIR="agents/$AGENT_NAME"

if [ -d "$AGENT_DIR" ]; then
  echo "❌ Agent already exists: $AGENT_NAME"
  exit 1
fi

echo "📦 Creating agent: $AGENT_NAME"

mkdir -p "$AGENT_DIR/prompts"
mkdir -p "$AGENT_DIR/scenarios"
mkdir -p "$AGENT_DIR/evals"

cat > "$AGENT_DIR/manifest.json" <<EOF
{
  "name": "$AGENT_NAME",
  "description": "Describe what this agent does",
  "model": "gpt-4o-mini",
  "systemPrompt": "prompts/system.txt",
  "inputs": [
    {
      "name": "input_text",
      "type": "string",
      "required": true
    }
  ],
  "outputs": [
    {
      "name": "response_text",
      "type": "string"
    }
  ],
  "tools": []
}
EOF

cat > "$AGENT_DIR/prompts/system.txt" <<EOF
You are an AI agent.
Describe your role and behavior here.
EOF

cat > "$AGENT_DIR/scenarios/basic.json" <<EOF
{
  "input": {
    "input_text": "Example input"
  },
  "expected_behavior": "Describe the expected behavior"
}
EOF

cat > "$AGENT_DIR/evals/golden.json" <<EOF
{
  "input": {
    "input_text": "Evaluation input"
  },
  "expected_output_contains": [
    "expected phrase"
  ]
}
EOF

echo "✅ Agent scaffold created at $AGENT_DIR"
echo "➡️ Next steps:"
echo "   - Edit manifest.json"
echo "   - Update system prompt"
echo "   - Add eval cases"
