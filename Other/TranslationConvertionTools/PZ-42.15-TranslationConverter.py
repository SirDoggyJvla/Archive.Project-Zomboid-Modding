#
# Project Zomboid v42.15 Translation Converter v1
# 
# Converts all Project Zomboid Translation .txt files found in subfolders to v42.15 compliant .json files.
#
# Author: MassCraxx
# Copilot was used for this.

import os
import json
import re
import sys

# Read text file with proper encoding
def read_text_file(path):
    try:
        with open(path, "r", encoding="utf-8") as f:
            return f.read()
    except UnicodeDecodeError:
        with open(path, "r", encoding="latin-1") as f:
            return f.read()

# Extract txt file entries
def extract_table_content(text):
    match = re.search(r"\{(.*)\}", text, re.DOTALL)
    if not match:
        return {}

    inner = match.group(1)
    entries = {}

    for line in inner.splitlines():
        line = line.strip().rstrip(",")
        if "=" in line:
            key, value = line.split("=", 1)
            key = key.strip()
            value = value.strip().strip('"')
            entries[key] = value

    return entries

# Remove underscore from keys
def clean_key(key):
    if "_" in key:
        return key.split("_", 1)[1]
    return key

# Extract PZ .txt language file to .json
def txt_to_json(root_folder):
    # look through all folders
    for folder, subfolders, files in os.walk(root_folder):
        for file in files:
            if file.lower().endswith(".txt"):
                txt_path = os.path.join(folder, file)

                # Determine output filename
                base = file[:-4]  # remove .txt
                parts = base.split("_")

                # Remove first underscore part, add .json
                if len(parts) > 1:
                    json_name = "_".join(parts[:-1]) + ".json"
                else:
                    json_name = base + ".json"

                json_path = os.path.join(folder, json_name)

                # Read and parse
                content = read_text_file(txt_path)
                parsed = extract_table_content(content)

                # Determine if this is the IG_UI file (no key cleaning)
                is_ig_ui = json_name.startswith("IG_UI")

                # Build JSON file
                output_dict = {}
                for k, v in parsed.items():
                    # Clean key if not IG_UI file
                    new_key = k if is_ig_ui else clean_key(k)
                    output_dict[new_key] = v

                # Write valid JSON
                with open(json_path, "w", encoding="utf-8") as f:
                    json.dump(output_dict, f, indent=4, ensure_ascii=False)

                print(f"Created: {json_path}")

if __name__ == "__main__":
    # Use script's own directory as root
    script_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    txt_to_json(script_dir)