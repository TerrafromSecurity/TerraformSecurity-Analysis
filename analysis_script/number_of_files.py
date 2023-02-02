from pathlib import Path

base_dir = "/Users/eliasberger/Documents/Uni/4_Semester/Hyperautomation/Generating-Terraform-configuration-files/data/aws-easy/"
human = base_dir + "human-tf/"
codex = base_dir + "codex-tf/"
codeparrot = base_dir + "codeparrot-large-tf/"
gpt_2 = base_dir + "gpt-2-large-tf/"

def get_number_of_terraform_files(dir):
    total_files = 0
    for i, p in enumerate(Path(dir).rglob("*")):
        if str(p).endswith(".tf"):
            total_files += 1

    return total_files


print("Number of human files", get_number_of_terraform_files(human))
print("Number of codex files", get_number_of_terraform_files(codex))
print("Number of codeparrot files", get_number_of_terraform_files(codeparrot))
print("Number of gpt-2 files", get_number_of_terraform_files(gpt_2))
