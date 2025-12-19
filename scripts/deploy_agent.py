import json
import sys
from pathlib import Path

def deploy_agent(agent_name, env):
    agent_dir = Path(f"agents/{agent_name}")
    manifest = json.loads((agent_dir / "manifest.json").read_text())
    prompt = (agent_dir / manifest["systemPrompt"]).read_text()

    print(f"Deploying agent '{agent_name}' to {env}")
    print(f"Model: {manifest['model']}")

    # PLACEHOLDER: Azure AI Foundry API call
    # This is where you later call:
    # - Azure AI Foundry agent/project API
    # - Or register agent config in App Config / Storage

    print(f"Agent {agent_name} deployed.")

if __name__ == "__main__":
    agent = sys.argv[1]
    env = sys.argv[2]
    deploy_agent(agent, env)
