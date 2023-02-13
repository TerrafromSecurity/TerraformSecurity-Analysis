# Description

This Repository is for the paper "Detecting Security Vulnerabilities in AI generated IaC Scripts" by Valentin Hartig, Elias Berger, Maximilian Frank and Felix Sandmair. It includes all the data we presented in our study and the scripts that were used to analyse this data. Additionally there is our research prototyp for generating secure Terraform scripts by using Auqasecuritys tfsec and OpenAIs ChatGPT. It also includes data collected by Oskar Bonde ([github](https://github.com/Oskar-Bonde/Generating-Terraform-configuration-files)) from his thesis "Generating Terraform Configuartion files with Large Language Models" that we used to compare some of our results to. 

# Prerequisits for Prototype

This is a List of requirements to run the prototype
* [tfsec](https://github.com/aquasecurity/tfsec)
* [ChatGPT_wrapper](https://github.com/mmabrouk/chatgpt-wrapper)
* python libraries:
    * pandas
    * numpy
    * pypandoc
    * panflute

# Usage of Prototpye

In order to use the prototype follow the explanation inside the Secure_terraform_Prototype.py.

# Results

We only analyse security issues for AWS, because that are the most accurate results. That's why only AWS errors are shown.

| Model      | Provider | % of files affected |
|------------|----------|---------------------|
| Codex      | AWS      | 89.15%              |
| GPT-2      | AWS      | 100%                |
| CodeParrot | AWS      | 89.74%              |
