import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import os
from pypandoc.pandoc_download import download_pandoc
import numpy as np

# download_pandoc()

prompts = [
    {"id": 1, "prompt": "Can you deploy an AWS EC2 instance."},
    # {"id": 2, "prompt": "Can you create a VPC gateway instance with elastic IP on AWS?"},
    # {"id": 3, "prompt": "Can you create a S3 Bucket on AWS?"},
    # {"id": 4, "prompt": "Can you provision a t2.micro instance on AWS?"},
    # {"id": 5, "prompt": "Can you deploy a web server with a public IP on AWS?"},
    # {"id": 6, "prompt": "Can you change the AMI of an AWS EC2 instance to Ubuntu 16.04?"},
]

settingsPrompts = [
    "Can you create terraform configuration code in the following?",
    "Don't forget the starting terraform block.",
    "Only print out a single code block per response.",
    "Fill any placeholders with dummy values.",
    "The code should be generated based on the following description."
]

# Check if directories exist
def init():
    # generate tmp folder if it does not exist
    if not os.path.exists("tmp"):
        print("create tmp folder")
        os.makedirs("tmp")

    # generate prompts and data folder if they do not exist
    if not os.path.exists("prompts"):
        print("create prompts folder")
        os.makedirs("prompts")

# Extract code from markdown
def extract_code() -> list[str]:
    def action(elem, doc):
        if isinstance(elem, panflute.CodeBlock):
            doc.code.append(elem)

    def prepare(doc):
        doc.code = []

    data = pypandoc.convert_file('tmp/chatgpt.md', 'json')
    doc = panflute.load(io.StringIO(data))
    doc = panflute.run_filter(action, prepare=prepare, doc=doc)
    return [code.text for code in doc.code]

# Parses a chatGPT response:
# - saves the entire response in markdown
# - splits out the code block
# - save the code block in a tf file
# - return the code
def parse_response(response: str) -> str:
    f = open("tmp/chatgpt.md", "w+")
    f.write(response)
    f.close()

    if debug:
        print(f"write response in tf file")

    code = "\n".join(extract_code())
    if os.path.exists("tmp/chatgpt.tf"):
        os.remove("tmp/chatgpt.tf")
    f = open(f"tmp/chatgpt.tf", "w+")
    f.write(code)
    f.close()

    return code

# Run tfSec on temporary data and output it as json
def run_tfSec():
    if debug:
        print(f"run tfsec")
    output = subprocess.run(["tfsec", f"tmp/", "-f", "json"], capture_output=True)
    return json.loads(output.stdout.decode("utf-8"))

# Analyse tfSec json output
def analyse_tfSec_output(output):
    issues: set = set()
    if output["results"] == None:
        return 0, issues
    else:
        for issue in output["results"]:
            issues.add(json.dumps(issue))
        return len(issues), issues

# Wrap up
def finish(code: str, data, id: int):
    # save final TF file
    f = open(f"prompts/prompt_{id}_final.tf", "w+")
    f.write(code)
    f.close()
    # save final data
    f = open(f"prompts/prompt_{id}.json", "w+")
    f.write(json.dumps(data))
    f.close()

# Execute the chatGPT runner for a single prompt
def createPrompt(inputPrompt):

    #These variables store the solution of the five attempts
    codeOfAttempts = []
    numOfVulnerabilities = []
    vulnerabilities = []
    
    # This loop makes 5 attempts at solving all security vulnerabilities (or less if we had one attempt that succeeded)
    for i in range(5):
        # Stores all the generated code blocks
        data = []
        id, prompt = inputPrompt.values()

        # (0) for the first question to chatgpt we add some setting prompts
        prompt = settings + "\n" + prompt

        # (1) Get first response and save to file
        if debug:
            print(f"### PROMPT: {prompt}")
            print("Waiting for response ... ")

        response = bot.ask(prompt)
        
        if debug:
            print("ChatGPT: \n", response)

        # (2) Extract code from markdown file and write to terraform file
        code = parse_response(response)

        # (3) run tfsec on the terraform file
        # (4) extract tfsec descriptions from the json output
        tfSecOutput = run_tfSec()

        # (5) check if tfsec found any issues
        number_of_issues, issuesToProcess = analyse_tfSec_output(tfSecOutput)

        # Append initial prompt to data
        data.append({
                "prompt": str(prompt),
                "code": str(code),
                "tfsec": str(tfSecOutput),
                "number_of_issues": str(number_of_issues)
            })

        processed_issues: set = set()
        resolved_issues: set = set()
        # (6) Run loop over all found issues and resolve issue by issue
        while True:
            # if issues set is empty we have tried to resolve all issues that we found
            if not issuesToProcess:
                break

            issue = issuesToProcess.pop()

            if debug:
                print("issue: " + issue)

            jsonIssue = json.loads(issue)

            processed_issues.add(jsonIssue["rule_id"])
            prompt = code + "\n" + "My code has the following security vulnerability. Can you fix this and " \
                                            "print out the full code? " + issue
                                            
            # Rerun the same request as long as the same issue persists in the code and no new issues have been introduced
            for attempt in range(3):
                response = bot.ask(prompt)
                codeTmp = parse_response(response)
                tfSecOutputTmp = run_tfSec()
                number_of_issues, issues = analyse_tfSec_output(tfSecOutput)
                issueIds: set = set()
                jsonIssues = json.loads(issues)
                for i in issues:
                    issueIds.add(i["rule_id"])
                if len(issueIds.intersection(resolved_issues)) == 0 and jsonIssue["rule_id"] not in issueIds:
                    resolved_issues.add(jsonIssue["rule_id"])
                    tfSecOutput = tfSecOutputTmp
                    code = codeTmp
                    for newIssue in jsonIssues:
                        if newIssue["rule_id"] not in processed_issues:
                            issuesToProcess.add(newIssue["rule_id"])
                    break

            data.append({
                "prompt": str(prompt),
                "code": str(code),
                "tfsec": str(tfSecOutput),
                "number_of_issues": str(number_of_issues)
            })

        # (5b) save all the data of this iteration to a json file
        codeOfAttempts.append(code)
        numOfVulnerabilities.append(number_of_issues)
        vulns = []
        for issue in jsonIssue:
            vulns.append(issue["rule_id"])
        vulnerabilities.append(vulns)
        finish(code, data, id)

        if number_of_issues == 0:
            break


    bestAttempt = np.argmin(numOfVulnerabilities)
    code = codeOfAttempts[bestAttempt]
    print("Here is a suggestion for a Tf script with the following description: " + prompt)
    print(code)
    print("There are " + str(np.min(numOfVulnerabilities)) + " security vulnerabilities left in this script.")
    for i, vuln in enumerate(vulnerabilities[bestAttempt]):
        print(f"Vulnerability {i}: {vuln}")





debug = True
bot = ChatGPT()

#test if ChatGPT bot is working

reponse = bot.ask("Hello")
if not (reponse == 'Your ChatGPT session is not usable.\n* Run this program with the `install` parameter and log in to ChatGPT.\n* If you think you are already logged in, try running the `session` command.'):
    settings = " ".join(settingsPrompts)
    init()

    for p in prompts:
        createPrompt(p)
else:
    print("ChatGPT is not working.")