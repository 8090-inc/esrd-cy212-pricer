import yaml
import sys
import os

def validate_rule(rule):
    """Basic validation to ensure the YAML resembles the DSL structure"""
    required_keys = ['rule_id', 'name', 'conditions', 'actions']
    for key in required_keys:
        if key not in rule:
            print(f"Error: Rule {rule.get('rule_id', 'UNKNOWN')} missing key '{key}'")
            return False
            
    if not isinstance(rule['conditions'], list):
         print(f"Error: Rule {rule.get('rule_id')} 'conditions' must be a list.")
         return False
         
    if not isinstance(rule['actions'], list):
         print(f"Error: Rule {rule.get('rule_id')} 'actions' must be a list.")
         return False
         
    print(f"Rule [{rule['rule_id']}] '{rule['name']}' syntactically VALID.")
    return True

def validate_file(filepath):
    print(f"Evaluating {filepath}...")
    try:
        with open(filepath, 'r') as stream:
             docs = yaml.safe_load_all(stream)
             all_valid = True
             for index, rule in enumerate(docs):
                 if rule is None:
                     continue
                 if isinstance(rule, list):
                     for r in rule:
                         if not validate_rule(r):
                             all_valid = False
                 else:
                     if not validate_rule(rule):
                         all_valid = False
             return all_valid
    except yaml.YAMLError as exc:
        print(f"YAML Parsing Error: {exc}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Usage: python {sys.argv[0]} <yaml_rule_file>")
        sys.exit(1)
        
    target = sys.argv[1]
    if os.path.isfile(target):
        sys.exit(0 if validate_file(target) else 1)
    else:
        print(f"Target {target} not found.")
        sys.exit(1)
