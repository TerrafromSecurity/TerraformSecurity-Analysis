import os
import pandas as pd

# get all json files that store our interactions with chatgpt
# these are the final, optimized files
json_files_final_run = [
    os.path.join(dp, f) for dp, dn, fn in os.walk("../data/strategy_A_results") for f in fn
    if ("final" in f) and f.endswith(".json")]

total_files = len(json_files_final_run)

# read all the data into a pandas dataframe
li = []
for filename in json_files_final_run:
    df = pd.read_json(filename)
    li.append(df)
frame_all_runs = pd.concat(li, axis=0, ignore_index=True)
frame_all_runs["number_of_issues"].astype(int)

# count number of columns where number_of_issues is 0
number_of_files_unaffected = len(frame_all_runs[frame_all_runs["number_of_issues"] > 0])

print(f"Number of files affected: {number_of_files_unaffected}")
print(f"Total number of files: {total_files}")

