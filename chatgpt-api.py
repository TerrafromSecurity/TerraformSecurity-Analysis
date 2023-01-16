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
    {"id": 1, "prompt": "CAn you deploy an AWS EC2 instance."},
    {"id": 2, "prompt": "Can you create a VPC gateway instance with elastic IP on AWS?"},
    {"id": 3, "prompt": "Can you create a S3 Bucket on AWS?"},
    {"id": 4, "prompt": "Can you provision a t2.micro instance on AWS?"},
    {"id": 5, "prompt": "Can you deploy a web server with a public IP on AWS?"},
    {"id": 6, "prompt": "Can you change the AMI of an AWS EC2 instance to Ubuntu 16.04?"},
]

settingsPrompts = [
    "Can you create terraform configuration code in the following?",
    "Don't forget the starting terraform block.",
    "Only print out a single code block per response.",
    "Fill any placeholders with dummy values.",
    "The code should be generated based on the following description."
]


def extract_code(file_name: str) -> list[str]:
    def action(elem, doc):
        if isinstance(elem, panflute.CodeBlock):
            doc.code.append(elem)

    def prepare(doc):
        doc.code = []

    data = pypandoc.convert_file('tmp/chatgpt.md', 'json')
    doc = panflute.load(io.StringIO(data))
    doc = panflute.run_filter(action, prepare=prepare, doc=doc)
    return [code.text for code in doc.code]


debug = True

bot = ChatGPT()
settings = " ".join(settingsPrompts)

# generate tmp folder if it does not exist
if not os.path.exists("tmp"):
    os.makedirs("tmp")

# generate prompts and data folder if they do not exist
if not os.path.exists("data/prompts"):
    os.makedirs("data/prompts")

run_id = 0 # update this after each run
for p in prompts:
    print("#### Starting new prompt ####")
    id, prompt = p.values()
    data = []
    # for the first question to chatgpt we add some settings
    prompt = settings + "\n" + prompt
    issues = 100000
    iteration = 0
    # use some high integer as an upper bound
    number_results_previous_run = 10**10
    while True:
        if debug:
            print(f"Prompt {id}: {prompt}")

        # (1) Get first response and save to file
        print("Waiting for response ... ")
        response = bot.ask(prompt)
        # response = "```\nterraform {\n  required_providers {\n    aws = {\n      source = \"hashicorp/aws\"\n    }\n  }\n}\n\nresource \"aws_instance\" \"example\" {\n  ami           = \"ami-0ff8a91507f77f867\"\n  instance_type = \"t2.micro\"\n\n  tags = {\n    Name = \"example\"\n  }\n}\n```\n"
        print("ChatGPT: \n", response)
        f = open("tmp/chatgpt.md", "w+")
        f.write(response)
        f.close()

        if debug:
            print(f"write response in tf file")
        # (2) Extract code from markdown file and write to terraform file
        code = "\n".join(extract_code(response))
        f = open(f"tmp/chatgpt.tf", "w+")
        f.write(code)
        f.close()

        if debug:
            print(f"run tfsec")
        # break
        # (3) run tfsec on the terraform file
        result = subprocess.run(["tfsec", "tmp/", "-f", "json"], capture_output=True)

        # (4) extract tfsec descriptions from the csv output
        tfSecOutput = json.loads(result.stdout.decode("utf-8"))

        # (5) append to data list
        data.append({
            "iteration": iteration + 1,
            "prompt": prompt,
            "response": response,
            "tfsec": result.stdout.decode("utf-8"),
        })

        f = open(f"data/prompts/prompt_{id}_run_{run_id}_save_{iteration}.json", "w+")
        f.write(json.dumps(data))
        f.close()

        # this is the new prompt
        prompt = "I detect the following security vulnerabilities, can you fix them?\n"

        counter = 0

        if len(tfSecOutput) == number_results_previous_run:
            print("No new results")
            break
        number_results_previous_run = len(tfSecOutput)
        print("Number of security issues: ", len(tfSecOutput))

        for issue in tfSecOutput["results"]:
            prompt = prompt + "Vulnerablitity " + str(counter) + ":\n"
            prompt = prompt + "rule_description: " + issue['rule_description'] + "\n"
            prompt = prompt + "impact: " + issue['impact'] + "\n"
            prompt = prompt + "resolution: " + issue['resolution'] + "\n"
            counter = counter + 1
        
        # the while loop stops once we got the same amout of issues or more then in the previous run
        if (counter >= issues) or (counter == 0):
            break
        else:
            issues = counter


    f = open(f"data/prompts/prompt_{id}_run_{run_id}.json", "w+")
    f.write(json.dumps(data))
    f.close()
