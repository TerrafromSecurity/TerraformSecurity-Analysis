import os
import subprocess
from pathlib import Path

# this file analyzes directories of terraform scripts created by these models
# and checks how many of them are affected by security vulnerabilities
# this is done by running tfsec on the directories and checking if the output isn't empty

base_dir = "/Users/eliasberger/Documents/Uni/4_Semester/Hyperautomation/Generating-Terraform-configuration-files/data/aws-easy/"
human = base_dir + "human-tf/"
codex = base_dir + "codex-tf/"
codeparrot = base_dir + "codeparrot-large-tf/"
gpt_2 = base_dir + "gpt-2-large-tf/"
chatgpt = "/Users/eliasberger/Documents/Programming/terraform-security-fixer/CodeGen_ChatGPT"

def get_number_of_terraform_files_affected(dir):
    files_affected = 0
    total_files = 0
    for i, p in enumerate(Path(dir).rglob("*")):
        if str(p).endswith(".tf"):
            total_files += 1
            result = subprocess.run(["tfsec", f"{str(os.path.dirname(p))}", "-f", "csv"], capture_output=True)
            if len(result.stdout.decode("utf-8")) > 66:
                files_affected += 1

    return files_affected


print("Number of human files affected", get_number_of_terraform_files_affected(human))
print("Number of codex files affected", get_number_of_terraform_files_affected(codex))
print("Number of codeparrot files affected", get_number_of_terraform_files_affected(codeparrot))
print("Number of gpt-2 files affected", get_number_of_terraform_files_affected(gpt_2))
print("Number of chatgpt files affected", get_number_of_terraform_files_affected(chatgpt))
# Number of gpt-2 files affected 245
# Number of chatgpt files affected 376