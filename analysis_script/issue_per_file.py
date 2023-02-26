import pandas as pd
import plotly.express as px


# compute the mean and std dev of the number of issues per file

df = pd.read_csv("../data/security_smells_AWS_Optimized_ChatGPT.csv")
df["issues"] = 1
number_of_issues = len(df)
df = df.groupby(["file"]).sum().reset_index()

df.to_csv("../data/security_smells_AWS_Optimized_ChatGPT_issues_per_file.csv")

mu = df["issues"].mean()
std_deviation = df["issues"].std()
print("mean", mu)
print("std_deviation", std_deviation)


px.histogram(df, x="issues")

# non optimized chat gpt
# mean 4.3243967828418235
# std_deviation 3.997898637979647

# optimized chat gpt
# mean 3.3095238095238093
# std_deviation 3.0562857678138067


# code parrot 11.995741660752307 (1409/2450/)
# codex 15.638