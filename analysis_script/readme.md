# Data Analysis
This directory contains the scripts used to analyze the data collected
It provides an overview of the data analysis process and the scripts used to perform the analysis.
Using the notebooks, you can reproduce the analysis and the figures presented in the paper.

- `issue_coocurrence.ipynb`: This notebook contains the code used to analyze the co-occurrence of issues in the data set
- `issue_per_file.ipynb`: Average number of security vulnerabilities per file
- `issue_per_iteration.ipynb`: Average number of security vulnerabilities per optimization iteration
- `number_of_issues_distribution.ipynb`: Distribution of the number of security vulnerabilities per file.
This also contains the statistical test (T-test and Kolmorogov-Smirnov) used to compare the distribution
- `number_of_files_affected.ipynb`: Computes fraction of number of files affected by at least one security vulnerability