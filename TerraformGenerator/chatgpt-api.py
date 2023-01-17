import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import os
from pypandoc.pandoc_download import download_pandoc

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
    if not os.path.exists("../tmp"):
        print("create tmp folder")
        os.makedirs("../tmp")

    # generate prompts and data folder if they do not exist
    if not os.path.exists("../data/prompts"):
        print("create prompts folder")
        os.makedirs("../data/prompts")

# Extract code from markdown
def extract_code() -> list[str]:
    def action(elem, doc):
        if isinstance(elem, panflute.CodeBlock):
            doc.code.append(elem)

    def prepare(doc):
        doc.code = []

    data = pypandoc.convert_file('../tmp/chatgpt.md', 'json')
    doc = panflute.load(io.StringIO(data))
    doc = panflute.run_filter(action, prepare=prepare, doc=doc)
    return [code.text for code in doc.code]

# Parses a chatGPT response:
# - saves the entire response in markdown
# - splits out the code block
# - save the code block in a tf file
# - return the code
def parse_response(response: str) -> str:
    f = open("../tmp/chatgpt.md", "w+")
    f.write(response)
    f.close()

    if debug:
        print(f"write response in tf file")

    code = "\n".join(extract_code())
    if os.path.exists("tmp/chatgpt.tf"):
        os.remove("../tmp/chatgpt.tf")
    f = open(f"tmp/chatgpt.tf", "w+")
    f.write(code)
    f.close()

    return code

# Run tfSec on temporary data and output it as json
def run_tfSec() -> str:
    if debug:
        print(f"run tfsec")
    output = subprocess.run(["tfsec", f"tmp/", "-f", "json"], capture_output=True)
    return json.loads(output.stdout.decode("utf-8"))

# Analyse tfSec json output
def analyse_tfSec_output(output):
    number_of_issues = len(output["results"])
    issues: set = output["results"]
    return number_of_issues, issues

# Wrap up
def finish(tries: int, code: str, data):
    print("All issues have been solved")
    # save final TF file
    f = open(f"data/prompts/prompt_{id}_final_{tries}.tf", "w+")
    f.write(code)
    f.close()
    # save final data
    f = open(f"data/prompts/prompt_{id}_final_{tries}.json", "w+")
    f.write(json.dumps(data))
    f.close()

# Execute the chatGPT runner for a single prompt
def createPrompt(inputPrompt):
    # Stores all the generated code blocks
    data = []
    id, prompt = inputPrompt.values()

    # (0) for the first question to chatgpt we add some setting prompts
    prompt = settings + "\n" + prompt

    # (1) Get first response and save to file
    print(f"### PROMPT: {prompt}")
    print("Waiting for response ... ")
    response = bot.ask(prompt)
    print("ChatGPT: \n", response)

    # (2) Extract code from markdown file and write to terraform file
    code = parse_response(response)

    # (3) run tfsec on the terraform file
    # (4) extract tfsec descriptions from the json output
    tfSecOutput = run_tfSec()

    # (5) check if tfsec found any issues
    number_of_issues, issues = analyse_tfSec_output(tfSecOutput)
    tries = 0

    # (6) Run loop over all found issues and resolve issue by issue
    while number_of_issues != 0:
        rerun: bool = True
        issue = issues.pop()
        print("issue", issue)
        resolved_issues: set = set()
        resolved_issues.add(issue)
        improvementPrompt = code + "\n" + "My code has the following security vulnerability. Can you fix this and " \
                                          "print out the full code? " + issue
        # Rerun the same request as long as the same issue persists in the code and no new issues have been introduced
        while rerun:
            imporvedResponse = bot.ask(improvementPrompt)
            code = parse_response(imporvedResponse)
            number_of_issues, issues = analyse_tfSec_output(run_tfSec())
            if len(resolved_issues.intersection(issue)) == 0:
                rerun = False

        tries = tries + 1
        data.append({
            "prompt": str(prompt),
            "response": str(response),
            "tfsec": str(tfSecOutput),
            "number_of_issues": str(number_of_issues)
        })

        # (5b) save all the data of this iteration to a json file
        f = open(f"data/prompts/prompt_{id}_try_{tries}.json", "w+")
        f.write(json.dumps(data))
        f.close()

    finish(tries, code, data)



debug = True
bot = ChatGPT()
settings = " ".join(settingsPrompts)
init()

for p in prompts:
    createPrompt(p)

