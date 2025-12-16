import json, os
from jsonschema import validate

with open("schemas/manifest.schema.json") as f:
    schema = json.load(f)

for root, _, files in os.walk("agents"):
    if "manifest.json" in files:
        with open(os.path.join(root, "manifest.json")) as f:
            manifest = json.load(f)
            validate(manifest, schema)

print("✅ Manifest validation passed")
