import json
import subprocess
from pathlib import Path
import sys

# --- CONFIG ---
RESOURCE_GROUP = "rg-ai-core"
TEMPLATE_FILE = "infra/core/main.bicep"
PARAMS_FILE = "infra/params/dev.json"
DEPLOY_SCRIPT = "scripts/deploy-dev.sh"

def deploy_infra():
    """
    Deploy the core infrastructure (Bicep) to the resource group.
    """
    print(f"🚀 Deploying infrastructure to {RESOURCE_GROUP}...")
    
    # Ensure script is executable (Linux/macOS)
    subprocess.run(["chmod", "+x", DEPLOY_SCRIPT], check=True)
    
    # Run the deployment script
    result = subprocess.run(["bash", DEPLOY_SCRIPT], capture_output=True, text=True)
    print(result.stdout)
    if result.returncode != 0:
        print(result.stderr)
        raise Exception("Infrastructure deployment failed")

def deploy_agent(agent_name: str):
    """
    Deploy a single agent using its manifest and prompt.
    """
    agent_dir = Path(f"agents/{agent_name}")
    manifest_file = agent_dir / "manifest.json"

    if not manifest_file.exists():
        raise FileNotFoundError(f"Manifest not found for agent: {agent_name}")

    with open(manifest_file) as f:
        manifest = json.load(f)

    print(f"🚀 Deploying agent: {manifest['name']}")
    print(f"Model: {manifest['model']}")
    print(f"System prompt: {manifest['systemPrompt']}")

    # Example: call a deployment pipeline or API here
    # For now, just simulate
    print(f"✅ {agent_name} deployment simulated successfully")

def main():
    if len(sys.argv) < 2:
        print("Usage: python deploy_agent.py <agent-name> | all")
        exit(1)

    target = sys.argv[1]

    # Deploy infra first
    deploy_infra()

    if target.lower() == "all":
        # Deploy all agents in agents/ folder
        agents_dir = Path("agents")
        for agent_name in [d.name for d in agents_dir.iterdir() if d.is_dir()]:
            deploy_agent(agent_name)
    else:
        deploy_agent(target)

    print("🎉 Deployment finished!")

if __name__ == "__main__":
    main()
