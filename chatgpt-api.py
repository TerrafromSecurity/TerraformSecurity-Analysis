import subprocess
import io
import pypandoc
import panflute
from chatgpt_wrapper import ChatGPT
import json
import pandas as pd
from pypandoc.pandoc_download import download_pandoc
# download_pandoc()

prompts = [
    "Can you create a Terraform script to deploy an AWS EC2 instance?",
    # "Can you create a VPC gateway instance with elastic IP on AWS?",
    # "Can you create a S3 Bucket on AWS?",
    # "Can you create an EC2 instance with a public IP on AWS?",
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
for i, prompt in enumerate(prompts):
    if debug:
        print(f"Prompt 1: {prompt}")
    # (1) Get first response and save to file
    response = bot.ask(prompt)
    print(response)
    f = open("tmp/chatgpt.md", "w")
    f.write(response)
    f.close()

    if debug:
        print("Response 1:", response)

    # (2) Extract code from markdown file and write to terraform file
    code = "\n".join(extract_code(response))
    f = open(f"tmp/chatgpt.tf", "w")
    f.write(code)
    f.close()
    # break
    # (3) run tfsec on the terraform file
    result = subprocess.run(["tfsec", "tmp/", "-f", "csv"], capture_output=True)

    # (4) extract tfsec descriptions from the csv output
    csv = io.StringIO()
    csv.write(result.stdout.decode("utf-8"))
    csv.seek(0)
    df = pd.read_csv(csv, header="infer")
    prompt_2 = "\n".join(df["description"].tolist())

    if debug:
        print("Prompt 2:", prompt_2)

    # (5) send the tfsec output to chatgpt
    response_2 = bot.ask(prompt_2)
    print(response)
    if debug:
        print("Response 2:", response_2)

    # (6) save the output to a file
    data = [{
        "prompt": prompt,
        "response": response
    }, {
        "prompt": prompt_2,
        "response": response_2
    }
    ]

    f = open(f"data/prompts/{i}.json", "w")
    f.write(json.dumps(data))
    f.close()
