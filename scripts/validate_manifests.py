import json
import os
import sys
from jsonschema import validate, ValidationError

SCHEMA_PATH = "schemas/manifest.schema.json"
AGENTS_DIR = "agents"

def load_schema():
    with open(SCHEMA_PATH, "r") as f:
        return json.load(f)

def validate_manifest(agent_name, schema):
    manifest_path = os.path.join(AGENTS_DIR, agent_name, "manifest.json")

    if not os.path.isfile(manifest_path):
        print(f"❌ Missing manifest.json for agent: {agent_name}")
        return False

    with open(manifest_path, "r") as f:
        manifest = json.load(f)

    try:
        validate(instance=manifest, schema=schema)
        print(f"✅ {agent_name} manifest valid")
        return True
    except ValidationError as e:
        print(f"❌ {agent_name} manifest invalid:")
        print(e.message)
        return False

def main():
    schema = load_schema()
    success = True

    for agent_name in os.listdir(AGENTS_DIR):
        agent_path = os.path.join(AGENTS_DIR, agent_name)
        if os.path.isdir(agent_path):
            if not validate_manifest(agent_name, schema):
                success = False

    if not success:
        print("\n🚫 Manifest validation failed")
        sys.exit(1)

    print("\n🎉 All agent manifests are valid")

if __name__ == "__main__":
    main()
