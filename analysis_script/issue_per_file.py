import pandas as pd

df = pd.read_csv("../data/security_smells_AWS_ChatGPT.csv")
number_of_issues = len(df)
number_of_files_affected = 376
number_of_issues_per_file = number_of_issues / number_of_files_affected
print(f"Number of issues: {number_of_issues}")
print(f"Number of issues per file: {number_of_issues_per_file}")


# ChatGPT 11.590425531914894
# Codex 3.504