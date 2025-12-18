import json
import os
from pathlib import Path

# Replace this with a real API call to your agent
def call_agent(agent_name, input_dict):
    """
    Mock agent call.
    Echoes all input fields so evals can validate expected phrases.
    """
    echoed_parts = []
    for key, value in input_dict.items():
        echoed_parts.append(f"{key}: {value}")

    return "Echo: " + " | ".join(echoed_parts)

def run_agent_eval(agent_name):
    eval_dir = Path(f"agents/{agent_name}/evals")
    if not eval_dir.exists():
        print(f"No evals found for {agent_name}")
        return True

    success = True
    for eval_file in eval_dir.glob("*.json"):
        with open(eval_file) as f:
            tests = json.load(f)

        for idx, test_case in enumerate(tests):
            input_data = test_case["input"]
            expected = test_case.get("expected_output_contains", [])
            output = call_agent(agent_name, input_data)

            failed = [phrase for phrase in expected if phrase.lower() not in output.lower()]
            if failed:
                success = False
                print(f"❌ {agent_name} - {eval_file.name} test {idx+1} failed. Missing: {failed}")
            else:
                print(f"✅ {agent_name} - {eval_file.name} test {idx+1} passed")

    return success

def main():
    agents_dir = Path("agents")
    overall_success = True

    for agent_name in os.listdir(agents_dir):
        if os.path.isdir(agents_dir / agent_name):
            print(f"\nRunning evals for {agent_name}")
            if not run_agent_eval(agent_name):
                overall_success = False

    if not overall_success:
        print("\n🚫 Some evals failed!")
        exit(1)
    print("\n🎉 All evals passed!")

if __name__ == "__main__":
    main()
